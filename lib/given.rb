require 'test_helper'
class TestHarness
  class Given
    include TestHarness::TestHelper

    Dir.glob(File.expand_path('../given/*.rb', __FILE__)).each do |file|
      klass = ("TestHarness::Given::%s" % File.basename(file, '.rb').camelize).constantize
      include klass
    end
  end
end


