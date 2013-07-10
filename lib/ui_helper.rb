class TestHarness
  class UIHelper
    def self.autoload
      TestHarness::Utilities.register_components('ui') do |component|
        klass = TestHarness::Utilities.constantize("%s::%s::%s" % [
          TestHarness.namespace,
          TestHarness::Utilities.camelize(component),
          self.name.split('::').last
        ])
        TestHarness.register_instance_option(self, component, klass.new)
        klass.send(:include, TestHarness::UIComponentHelper)
      end
    end
  end
end
