class TestHarness
  class UIHelper
    def self.autoload
      Dir.glob(File.join(TestHarness.autoload_path, 'ui/*.rb')).each do |file|
        component =  File.basename(file, '.rb')
        require File.join(TestHarness.autoload_path, 'ui', component)
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