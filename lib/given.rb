require 'test_helper'
class TestHarness
  class Given
    def mm
      TestHarness.mm
    end

    def self.autoload
      TestHarness::Utilities.register_components('given') do |component|
        klass = TestHarness::Utilities.constantize("%s::Given::%s" % [
          TestHarness.namespace,
          TestHarness::Utilities.camelize(component)
        ])
        include klass
      end
    end
  end
end


