$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "rails/asset_local_precompilation/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "rails-asset_local_precompilation"
  spec.version     = Rails::AssetLocalPrecompilation::VERSION
  spec.authors     = ["labocho"]
  spec.email       = ["labocho@penguinlab.jp"]
  # spec.homepage    = "TODO"
  spec.summary     = "Set of capistrano task and initializer for local asset compiling_with asset_sync, ckeditor"
  spec.description = "Set of capistrano task and initializer for local asset compiling_with asset_sync, ckeditor"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "activerecord-nulldb-adapter", ">= 0.4"
  spec.add_dependency "capistrano", "~> 3.11"
  spec.add_dependency "rails", ">= 5.0.0"

  spec.add_development_dependency "rubocop", "~> 0.75.1"
  spec.add_development_dependency "sqlite3", ">= 1.4.1"
end
