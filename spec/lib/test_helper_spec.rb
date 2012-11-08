require 'spec_helper'

class TestHelperWrapper
  extend TestHarness::TestHelper
end

describe TestHarness::TestHelper do
  [:configuration, :given, :uiv, :uid, :mm, :to].each do |method|
    it "delegates #{method} to TestHarness" do
      TestHarness.should_receive(method).and_return('sleepy_monkeys')
      TestHelperWrapper.send(method).should == 'sleepy_monkeys'
    end
  end

  it "adds methods to access given & ui components" do
    TestHarness.autoload
    TestHelperWrapper.given.a_boring_test.should ==
      :a_fancy_and_inspiring_result
    TestHelperWrapper.uiv.ui_test.lookies.should == :lovely_landscapes
    TestHelperWrapper.uid.ui_test.dainty_gloves.should == :handy_holders
  end
end