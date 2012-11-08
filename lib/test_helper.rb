class TestHarness
  module TestHelper
    def method_missing(method, *args)
      if [:configuration, :given, :uiv, :uid, :mm, :to].include?(method)
        TestHarness.send(method)
      else
        super
      end
    end

    def browser
      configuration.browser
    end
  end
end
