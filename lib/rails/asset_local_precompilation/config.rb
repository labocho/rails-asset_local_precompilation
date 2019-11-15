module Rails
  module AssetLocalPrecompilation
    class Config
      attr_accessor :use_ckeditor, :use_asset_sync, :asset_host

      def initialize
        self.use_ckeditor = false
        self.use_asset_sync = false
        self.asset_host = nil
      end
    end
  end
end
