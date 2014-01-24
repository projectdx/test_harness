require File.expand_path('../ui_test.rb', __FILE__)
class FakeHarness
  class Dandylions
    class InheritedUiTest < UiTest
      class UIView
        def lookies
          :wonderful_waterfalls
        end
      end
    end
  end
end
