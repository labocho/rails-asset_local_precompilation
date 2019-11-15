module AssetLocalPrecompilation
  class InstallGenerator < Rails::Generators::Base
    def create_asset_local_precompilation_file
      create_file "config/initializers/asset_local_precompilation.rb", <<~RUBY
        Rails::AssetLocalPrecompilation.configure do |config|
          # config.use_asset_sync = true # default: false
          # config.use_ckeditor = true # default: false
          # config.asset_host = "//assets.example.com" # to use S3 backended CloudFront, default: nil (guess from AssetSync.config.fog_directory)
        end
        Rails::AssetLocalPrecompilation.initialize!
      RUBY
    end
  end
end
