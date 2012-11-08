require 'spec_helper'
require 'utilities'

describe TestHarness::Utilities do
  describe ".camelize" do
    it "camelizes underscored word" do
      TestHarness::Utilities.camelize('furby_catchment_vice').should ==
        'FurbyCatchmentVice'
    end
  end

  describe ".constantize" do
    it "constantizes camel-cased word" do
      TestHarness::Utilities.constantize('TestHarness::Utilities').should ==
        TestHarness::Utilities
    end
  end
end