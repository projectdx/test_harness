require 'spec_helper'

describe TestHarness do
  describe ".autoload" do
    it "delegates autoload to all three concerns" do
      TestHarness::UIView.should_receive(:autoload)
      TestHarness::UIDriver.should_receive(:autoload)
      TestHarness::Given.should_receive(:autoload)

      TestHarness.autoload
    end

    it "actually loads all givens and registers all UI components" do
      TestHarness.autoload

      defined?(FakeHarness::Given::GivenTest).should be_true
      [FakeHarness::UiTest::UIView, FakeHarness::UiTest::UIDriver].each do |kl|
        TestHarness.registered_components.map(&:class).should include(kl)
      end
    end
  end
end