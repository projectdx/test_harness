require 'test_helper'
class TestHarness
  class Given
    def mm
      TestHarness.mm
    end

    def self.autoload
      Dir.glob(File.join(TestHarness.autoload_path, 'given/*.rb')).each do |file|
        component =  File.basename(file, '.rb')
        require File.join(TestHarness.autoload_path, 'given', component)
        klass = TestHarness::Utilities.constantize("%s::Given::%s" % [
          TestHarness.namespace,
          TestHarness::Utilities.camelize(File.basename(file, '.rb'))
        ])
        include klass
      end
    end
  end
end


