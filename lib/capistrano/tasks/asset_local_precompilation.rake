set :rsync_ssh_command, "ssh"
set :use_asset_sync, false
set :use_yarn, true
set :fog_directory, nil
set :fog_region, nil
set :asset_host, nil # bootstrap-sass gem など precompile 時に asset_host を使う場合に指定する必要がある
set :local_precompilation_env, -> {
  {"SECRET_KEY_BASE": ENV.fetch("SECRET_KEY_BASE", "DUMMY")}
}

namespace :assets do
  task :local_precompile_and_sync do
    use_sprockets = true
    use_webpacker = false
    use_vite = false

    run_locally do
      # 通常 assets:precompile 後にassets:syncが実行されるが、config/initializers/asset_sync.rb で config.run_on_precompile = false としてこの動作を止めている。
      # assets:precompile 後に webpacker:compile が呼ばれる
      # tmp/cache/assets があると、ckeditor の asset_path の変更が反映されない場合がある
      execute "rm -rf public/assets public/packs tmp/cache/assets tmp/cache/webpacker"

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

      use_webpacker = ::Dir.exist?("public/packs")
      use_sprockets = ::Dir.exist?("public/assets")
      use_vite = ::Dir.exist?("public/.vite")
    end

    on roles(:web) do |server|
      execute :mkdir, "-pv", "#{release_path}/public/assets" if use_sprockets
      execute :mkdir, "-pv", "#{release_path}/public/packs" if use_webpacker
      execute :mkdir, "-pv", "#{release_path}/public/.vite" if use_vite

      run_locally do
        execute :rsync, "-e", fetch(:rsync_ssh_command).shellescape, "-rv", "public/assets/", "#{server.user}@#{server.hostname}:#{release_path}/public/assets" if use_sprockets
        execute :rsync, "-e", fetch(:rsync_ssh_command).shellescape, "-rv", "public/packs/", "#{server.user}@#{server.hostname}:#{release_path}/public/packs" if use_webpacker
        execute :rsync, "-e", fetch(:rsync_ssh_command).shellescape, "-rv", "public/.vite/", "#{server.user}@#{server.hostname}:#{release_path}/public/.vite" if use_vite
      end

      if fetch(:use_asset_sync)
        within release_path do
          execute :bundle, "exec rake assets:sync --trace RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end

    run_locally do
      execute "yarn install --check-files" if fetch(:use_yarn)
      execute "rm -rf public/assets public/packs"
    end
  end

  after "deploy:updated", "assets:local_precompile_and_sync"
end
