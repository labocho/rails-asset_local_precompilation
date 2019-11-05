Rails::AssetLocalPrecompilation.configure do |config|
  config.use_asset_sync = true
  config.use_ckeditor = true
end
Rails::AssetLocalPrecompilation.initialize!
