class TestHarness
  class Configuration
    attr_accessor :browser, :server_host, :autoload_path

    def setup_cucumber_hooks(scope)
        scope.Before do
          TestHarness.reset
        end
    end
  end
end
