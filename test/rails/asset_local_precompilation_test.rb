require "test_helper"

module Rails
  module AssetLocalPrecompilation
    class Test < ActiveSupport::TestCase
      test "truth" do
        assert_kind_of Module, AssetLocalPrecompilation
      end
    end
  end
end
