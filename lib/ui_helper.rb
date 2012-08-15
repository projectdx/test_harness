class TestHarness
  class UIHelper
    def self.register_ui_components
      Dir.glob(File.expand_path('../ui/*.rb', __FILE__)).each do |file|
        component =  File.basename(file, '.rb')
        klass = ("TestHarness::%s::%s" % [component.camelize, self.name.split('::').last]).constantize
        TestHarness.register_instance_option(self, component, klass.new)
        klass.send(:include, TestHarness::UIComponentHelper)
        klass.send(:include, TestHarness::TestHelper)
      end
    end
  end
end
