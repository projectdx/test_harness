class TestHarness
  class UIHelper
    def self.register_ui_components
      Dir.glob(Rails.root.join(TestHarness.autoload_path, 'ui/*.rb')).each do |file|
        component =  File.basename(file, '.rb')
        require Rails.root.join(TestHarness.autoload_path, 'ui', component)
        klass = ("TestHarness::%s::%s" % [component.camelize, self.name.split('::').last]).constantize
        TestHarness.register_instance_option(self, component, klass.new)
        klass.send(:include, TestHarness::UIComponentHelper)
        klass.send(:include, TestHarness::TestHelper)
      end
    end
  end
end
