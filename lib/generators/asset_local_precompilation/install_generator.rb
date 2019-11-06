module AssetLocalPrecompilation
  class InstallGenerator < Rails::Generators::Base
    def create_asset_local_precompilation_file
      create_file "config/initializers/asset_local_precompilation.rb", <<~RUBY
        Rails::AssetLocalPrecompilation.configure do |config|
          # config.use_asset_sync = true # default: false
          # config.use_ckeditor = true # default: false
        end
        Rails::AssetLocalPrecompilation.initialize!
      RUBY
    end
  end
end
