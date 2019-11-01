//= require ckeditor/config
//= require ./load_plugins
(function() {
  var originalConfig = CKEDITOR.editorConfig;
  CKEDITOR.editorConfig = function (config) {
    originalConfig(config);
    config.extraPlugins = 'showblocks';
  }
}());
