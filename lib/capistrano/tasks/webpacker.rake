# capistrano-rails-1.2.3/lib/capistrano/tasks/assets.rake を元に記述

namespace :yarn do
  task :install do
    on release_roles(fetch(:packs_roles)) do
      within release_path do
        execute :yarn, "install"
      end
    end
  end
end

before "deploy:assets:precompile", "yarn:install"

# we can"t set linked_dirs in load:defaults,
# as packs_prefix will always have a default value
namespace :deploy do
  task :set_linked_dirs do
    linked_dirs = fetch(:linked_dirs, [])
    unless linked_dirs.include?("public")
      linked_dirs << "public/#{fetch(:packs_prefix)}"
      linked_dirs << "node_modules"
      set :linked_dirs, linked_dirs.uniq
    end
  end
end

after "deploy:set_rails_env", "deploy:set_linked_dirs"

namespace :load do
  task :defaults do
    set :packs_roles, fetch(:packs_roles, [:web])
    set :packs_prefix, fetch(:packs_prefix, "packs")
  end
end
