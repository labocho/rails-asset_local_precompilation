require "asset_tasks/railtie"

module AssetTasks
  require "asset_tasks/config"

  def self.config
    @config ||= Config.new
  end

  def self.configure
    yield config
  end

  # rubocop: disable Style/GuardClause
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
      AssetSync.config.run_on_precompile = false

      if (bucket = AssetSync.config.fog_directory || ENV["FOG_DIRECTORY"])
        region = AssetSync.config.fog_region || ENV["FOG_REGION"]
        asset_host = if bucket["."]
          "//s3#{region && "-#{region}"}.amazonaws.com/#{bucket}"
        else
          "//#{bucket}.s3.amazonaws.com"
        end

        Rails.application.config.action_controller.asset_host = asset_host

        if config.use_ckeditor
          Ckeditor.setup do |config|
            config.asset_path = "#{asset_host}/assets/ckeditor/"
          end
        end
      end

      if defined?(Webpacker)
        AssetSync.config.add_local_file_paths do
          # Support webpacker assets
          public_root = Rails.root.join("public")
          Dir.chdir(public_root) do
            packs_dir = Webpacker.config.public_output_path.relative_path_from(public_root)
            Dir[File.join(packs_dir, "/**/**")]
          end
        end
      end

      # config.assets.initialize_on_precompile is set to true

    end
    # rubocop: enable Style/GuardClause
  end
end
