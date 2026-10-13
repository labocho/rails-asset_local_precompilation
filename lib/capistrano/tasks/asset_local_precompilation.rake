require "shellwords"

set :rsync_ssh_command, "ssh"
set :use_asset_sync, false
set :use_yarn, true
set :fog_directory, nil
set :fog_region, nil
set :asset_host, nil # bootstrap-sass gem など precompile 時に asset_host を使う場合に指定する必要がある
set :local_precompilation_env, -> {
  {"SECRET_KEY_BASE": ENV.fetch("SECRET_KEY_BASE", "DUMMY")}
}
# precompile して rsync する assets のディレクトリのリスト
# 設定ファイルの有無から推測する
set :local_precompilation_assets_dirs, -> {
  defaults = []
  defaults << "public/assets" if File.exist?("app/assets/config/manifest.js")
  defaults << "public/packs" if File.exist?("config/webpacker.yml") || File.exist?("webpack.config.js")
  if File.exist?("vite.config.js") || File.exist?("vite.config.ts") || File.exist?("vite.config.mjs") || File.exist?("vite.config.mts")
    defaults << "public/packs"
    defaults << "public/.vite"
  end
  defaults.uniq!
  defaults
}

namespace :assets do
  task :local_precompile_and_sync do
    run_locally do
      # 通常 assets:precompile 後にassets:syncが実行されるが、config/initializers/asset_sync.rb で config.run_on_precompile = false としてこの動作を止めている。
      # assets:precompile 後に webpacker:compile が呼ばれる
      # tmp/cache/assets があると、ckeditor の asset_path の変更が反映されない場合がある
      execute "rm -rf #{fetch(:local_precompilation_assets_dirs).shelljoin} tmp/cache/assets tmp/cache/webpacker"

      env = {
        DATABASE_URL: "nulldb://localhost",
        RAILS_ENV: fetch(:rails_env),
      }.merge(fetch(:local_precompilation_env))

      if fetch(:use_asset_sync)
        raise "Please set fog_directory" unless fetch(:fog_directory)

        env.merge!(
          FOG_DIRECTORY: fetch(:fog_directory),
          FOG_REGION: fetch(:fog_region),
          ASSET_HOST: fetch(:asset_host),
        )
      end

      execute "rake assets:precompile --trace #{env.map {|k, v| "#{k}=#{v}" }.join(" ")}"
    end

    on roles(:web) do |server|
      fetch(:local_precompilation_assets_dirs).each do |assets_dir|
        execute :mkdir, "-pv", "#{release_path}/#{assets_dir}"
      end

      run_locally do
        fetch(:local_precompilation_assets_dirs).each do |assets_dir|
          execute :rsync, "-e", fetch(:rsync_ssh_command).shellescape, "-rv", "#{assets_dir}/", "#{server.user}@#{server.hostname}:#{release_path}/#{assets_dir}/"
        end
      end

      if fetch(:use_asset_sync)
        within release_path do
          execute :bundle, "exec rake assets:sync --trace RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end

    run_locally do
      execute "yarn install --check-files" if File.exist?("yarn.lock")
      execute "rm -rf #{fetch(:local_precompilation_assets_dirs).shelljoin}"
    end
  end

  after "deploy:updated", "assets:local_precompile_and_sync"
end
