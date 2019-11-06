module AssetLocalPrecompilation
  class CkeditorGenerator < Rails::Generators::Base
    def create_ckeditor_file
      create_file "app/assets/javascripts/ckeditor/register_plugins.js.erb", <<~ERB
        <% Dir.glob("*", base: Rails.root + "app/assets/javascripts/ckeditor/plugins").each do |plugin| %>
        CKEDITOR.plugins.addExternal('<%= plugin %>', '<%= asset_path("/assets/ckeditor/plugins/\#{plugin}/plugin.js") %>');
        <% end %>
      ERB

      create_file "app/assets/javascripts/ckeditor/config_override.js", <<~JS
        //= require ckeditor/config
        //= require ./register_plugins
        (function() {
          var originalConfig = CKEDITOR.editorConfig;
          CKEDITOR.editorConfig = function (config) {
            originalConfig(config);
            // config.extraPlugins = 'foo,bar';
          }
        }());
      JS
    end
  end
end
