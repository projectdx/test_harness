require 'configuration'
require 'utilities'

class TestHarness
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def autoload
      TestHarness::Given.autoload
      TestHarness::UIView.autoload
      TestHarness::UIDriver.autoload
    end

    def configure(&block)
      yield configuration
    end

    def reset
      @mm = nil
      registered_components.each(&:reset)
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
      @path ||= configuration.autoload_path || 'test_harness'
    end

    def namespace
      @namespace ||= configuration.namespace || 'TestHarness'
    end

    def registered_components
      @components ||= []
    end

    def register_instance_option(scope, option_name, instance)
      return if registered_components.any? { |c| c.is_a? instance.class }
      registered_components << instance
      scope.send(:define_method, option_name) do
        instance
      end
    end
  end
end

require 'given'
require 'ui_helper'

require 'ui_component'
require 'ui_component_helper'
require 'ui_driver'
require 'ui_view'
require 'mental_model'
