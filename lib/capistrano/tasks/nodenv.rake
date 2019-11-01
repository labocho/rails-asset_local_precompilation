# capistrano-rbenv-2.1.0/lib/capistrano/tasks/rbenv.rake を元に記述
# ただし rake, rails は nodenv exec で実行できないので (nodenv の shims にないため)、
# nodenv exec のかわりに PATH を指定することにした。
namespace :nodenv do
  task :validate do
    on release_roles(fetch(:nodenv_roles)) do
      nodenv_node = fetch(:nodenv_node)
      if nodenv_node.nil?
        warn "nodenv: nodenv_node is not set"
      end

      # don't check the nodenv_node_dir if :nodenv_node is not set (it will always fail)
      unless nodenv_node.nil? || (test "[ -d #{fetch(:nodenv_node_dir)} ]")
        warn "nodenv: #{nodenv_node} is not installed or not found in #{fetch(:nodenv_node_dir)}"
        exit 1
      end
    end
  end

  task :map_bins do
    SSHKit.config.default_env.merge!(nodenv_root: fetch(:nodenv_path), nodenv_version: fetch(:nodenv_node))
    nodenv_prefix = fetch(:nodenv_prefix, proc { "PATH=#{fetch(:nodenv_node_dir)}/bin:$PATH" })
    SSHKit.config.command_map[:nodenv] = "#{fetch(:nodenv_path)}/bin/nodenv"

    fetch(:nodenv_map_bins).each do |command|
      SSHKit.config.command_map.prefix[command.to_sym].unshift(nodenv_prefix)
    end
  end
end

Capistrano::DSL.stages.each do |stage|
  after stage, "nodenv:validate"
  after stage, "nodenv:map_bins"
end

namespace :load do
  task :defaults do
    set :nodenv_path, -> {
      nodenv_path = fetch(:nodenv_custom_path)
      nodenv_path ||= if fetch(:nodenv_type, :user) == :system
        "/usr/local/nodenv"
      else
        "$HOME/.nodenv"
      end
      nodenv_path
    }

    set :nodenv_roles, fetch(:nodenv_roles, :all)

    set :nodenv_node_dir, -> { "#{fetch(:nodenv_path)}/versions/#{fetch(:nodenv_node)}" }
    set :nodenv_map_bins, %w(rake rails yarn)
  end
end
