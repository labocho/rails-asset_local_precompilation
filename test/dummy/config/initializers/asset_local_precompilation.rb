Rails::AssetLocalPrecompilation.configure do |config|
  config.use_asset_sync = true
  config.use_ckeditor = true
  # config.asset_host = "//assets.example.com"
end
Rails::AssetLocalPrecompilation.initialize!
