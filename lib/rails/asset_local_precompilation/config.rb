module Rails
  module AssetLocalPrecompilation
    class Config
      attr_accessor :use_ckeditor, :use_asset_sync

      def initialize
        self.use_ckeditor = false
        self.use_asset_sync = false
      end
    end
  end
end
