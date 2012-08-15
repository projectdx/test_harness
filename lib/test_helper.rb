class TestHarness
  module TestHelper
    delegate :configuration, :given, :uiv, :uid, :mm, :to => TestHarness

    def browser
      configuration.browser
    end
  end
end
