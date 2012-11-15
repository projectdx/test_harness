require 'spec_helper'

describe "UIComponentHelper" do
  describe "#browser" do
    it "raises error for missing browser" do
      TestHarness.autoload
      expect {FakeHarness::UiTest::UIView.new.browser}.to raise_error(MissingConfiguration, 'TestHarness.browser must be defined')
    end

    it 'returns browser defined in TestHarness.configuration' do
      TestHarness.configuration.browser = :whatever
      TestHarness.autoload
      FakeHarness::UiTest::UIView.new.browser.should == :whatever
    end
  end
end
