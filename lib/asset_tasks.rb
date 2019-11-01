require "asset_tasks/railtie"

module AssetTasks
  require "asset_tasks/config"

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end

  def self.initialize!
    if config.use_ckeditor
      Ckeditor.setup do |config|
        config.js_config_url = "ckeditor/config_override.js"
      end

      Rails.application.config.assets.precompile += %w(
        ckeditor/application.css
        ckeditor/application.js
        ckeditor/config_override.js
      )

      Rails.application.config.assets.precompile += Dir.glob("ckeditor/plugins/**/*", base: (Rails.root + "app/assets/javascripts").to_s).to_a
    end

    if config.use_asset_sync
    end
  end
end
