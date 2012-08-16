require 'given'
require 'ui_component'
require 'configuration'

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

