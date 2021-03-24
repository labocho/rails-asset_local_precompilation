set :rsync_ssh_command, "ssh"
set :use_asset_sync, false
set :fog_directory, nil
set :fog_region, nil

namespace :assets do
  task :local_precompile_and_sync do
    use_sprockets = true
    use_webpacker = false

    run_locally do
      # 通常 assets:precompile 後にassets:syncが実行されるが、config/initializers/asset_sync.rb で config.run_on_precompile = false としてこの動作を止めている。
      # assets:precompile 後に webpacker:compile が呼ばれる
      # tmp/cache/assets があると、ckeditor の asset_path の変更が反映されない場合がある
      execute "rm -rf public/assets public/packs tmp/cache/assets tmp/cache/webpacker"

      if fetch(:use_asset_sync)
        raise "Please set fog_directory" unless fetch(:fog_directory)

        execute "rake assets:precompile --trace RAILS_ENV=#{fetch(:rails_env)} DATABASE_URL=nulldb://localhost FOG_DIRECTORY=#{fetch(:fog_directory)} FOG_REGION=#{fetch(:fog_region)}"
      else
        execute "rake assets:precompile --trace RAILS_ENV=#{fetch(:rails_env)}"
      end

      execute "yarn install --check-files" if (use_webpacker = ::Dir.exist?("public/packs"))
      use_sprockets = ::Dir.exist?("public/assets")
    end

    on roles(:web) do |server|
      execute :mkdir, "-pv", "#{release_path}/public/assets" if use_sprockets
      execute :mkdir, "-pv", "#{release_path}/public/packs" if use_webpacker

      run_locally do
        execute :rsync, "-e", fetch(:rsync_ssh_command).shellescape, "-rv", "public/assets/", "#{server.user}@#{server.hostname}:#{release_path}/public/assets" if use_sprockets
        execute :rsync, "-e", fetch(:rsync_ssh_command).shellescape, "-rv", "public/packs/", "#{server.user}@#{server.hostname}:#{release_path}/public/packs" if use_webpacker
      end

      if fetch(:use_asset_sync)
        within release_path do
          execute :bundle, "exec rake assets:sync --trace RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end
  end

  after "deploy:updated", "assets:local_precompile_and_sync"
end
