//= require ckeditor/config
//= require ./register_plugins
(function() {
  var originalConfig = CKEDITOR.editorConfig;
  CKEDITOR.editorConfig = function (config) {
    originalConfig(config);
    config.extraPlugins = 'showblocks';
    config.toolbar = config.toolbar + {name: "plugins", items: ["ShowBlocks"]}
  }
}());
