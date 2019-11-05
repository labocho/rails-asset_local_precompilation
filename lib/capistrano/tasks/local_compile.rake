set :rsync_ssh_command, "ssh"
set :use_asset_sync, false

namespace :assets do
  task :local_compile_and_sync do
    run_locally do
      # 通常 assets:precompile 後にassets:syncが実行されるが、config/initializers/asset_sync.rb で config.run_on_precompile = false としてこの動作を止めている。
      # assets:precompile 後に webpacker:compile が呼ばれる
      # tmp/cache/assets があると、ckeditor の asset_path の変更が反映されない場合がある
      execute "rm -rf public/packs tmp/cache/assets"
      execute "bundle exec rake assets:clean assets:precompile --trace RAILS_ENV=#{fetch(:rails_env)}"
      execute "yarn install --check-files"
    end

    on roles(:web) do |server|
      execute :mkdir, "-pv", "#{release_path}/public/assets"
      execute :mkdir, "-pv", "#{release_path}/public/packs"

      run_locally do
        execute :rsync, "-e", fetch(:rsync_ssh_command).shellescape, "-rv", "public/assets/", "#{server.user}@#{server.hostname}:#{release_path}/public/assets"
        execute :rsync, "-e", fetch(:rsync_ssh_command).shellescape, "-rv", "public/packs/", "#{server.user}@#{server.hostname}:#{release_path}/public/packs"
      end

      if fetch(:use_asset_sync)
        within release_path do
          execute :bundle, "exec rake assets:sync --trace RAILS_ENV=#{fetch(:rails_env)}"
        end
      end
    end
  end

  after "deploy:updated", "assets:local_compile_and_sync"
end
