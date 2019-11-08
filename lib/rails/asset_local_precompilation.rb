require "rails/asset_local_precompilation/railtie"

module Rails
  module AssetLocalPrecompilation
    require "rails/asset_local_precompilation/config"

    def self.config
      @config ||= Config.new
    end

    def self.configure
      yield config
    end

    # rubocop: disable Style/GuardClause
    def self.initialize!
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

        if config.use_ckeditor
          AssetSync.config.add_local_file_paths do
            # add ckeditor files
            public_root = Rails.root.join("public")
            Dir.chdir(public_root) do
              Dir["assets/ckeditor/**/*"]
            end
          end
        end
      end

      if config.use_ckeditor
        Ckeditor.setup do |config|
          config.js_config_url = "ckeditor/config_override.js"

          # ファイルブラウザでアップロードしたときにアイコンのパスが不適切なものになる問題に対応
          config.relative_path = ActionController::Base.helpers.asset_path("/assets/ckeditor")
          config.asset_path = "/assets/ckeditor/"
        end

        Rails.application.config.assets.precompile += %w(
          ckeditor/application.css
          ckeditor/application.js
          ckeditor/config_override.js
        )

        Rails.application.config.assets.precompile += Dir.glob("ckeditor/filebrowser/thumbs/*", base: Ckeditor.root_path.join("app/assets/images").to_s).to_a # filebrowser icons
        Rails.application.config.assets.precompile += Dir.glob("ckeditor/plugins/**/*", base: (Rails.root + "app/assets/javascripts").to_s).to_a
      end
      # rubocop: enable Style/GuardClause
    end
  end
end
