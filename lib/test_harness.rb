class TestHarness
  class << self
    def configuration
      @configuation ||= Configuration.new
    end

    def configure(&block)
      yield configuration
    end

    def given
      @given ||= TestHarness::Given.new
    end

    def uiv
      @uiv ||= TestHarness::UIView.new
    end

    def uid
      @uid ||= TestHarness::UIDriver.new
    end

    def mm
      @mm ||= TestHarness::MentalModel.new
    end

    def autoload_path
      @path = Configuration.autoload_path || 'test_harness'
    end

    def register_instance_option(scope, option_name, default_value = nil)
      scope.send(:define_method, option_name) do |*args, &block|
        if !args[0].nil? || block
          instance_variable_set("@#{option_name}_registered", args[0].nil? ? block : args[0])
        else
          instance_variable_get("@#{option_name}_registered") || default_value || yield
        end
      end
    end
  end
end

require 'given'
require 'ui_helper'

require 'ui_component'
require 'ui_component_helper'
require 'configuration'
require 'ui_driver'
require 'ui_view'
require 'mental_model'
