require 'spec_helper'

describe TestHarness::Given do
  describe "#mm" do
    it "delegates to TestHarness" do
      TestHarness.should_receive(:mm).and_return('no_rainforests_in_iowa')
      TestHarness::Given.new.mm.should == 'no_rainforests_in_iowa'
    end
  end
end