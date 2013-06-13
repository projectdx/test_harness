require 'spec_helper'
require 'active_support/core_ext/hash/indifferent_access'

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

  describe '#component_path' do
    before :each do
      TestHarness.reset
    end
    context 'string' do

      context 'mm.subject is a string' do
        before :each do
          TestHarness.autoload
          FakeHarness::UiTest.component.path = 'cows/:cow_id'
          @view = FakeHarness::UiTest::UIView.new
        end

        it 'returns the path with the tokens substituted from the mm.subject' do
          TestHarness.mm.subject = OpenStruct.new(:cow_id => 23)
          @view.send(:component_path).should == 'cows/23'
        end

        it 'handles multiple tokens' do
          FakeHarness::UiTest.component.path = 'cows/:cow_id/:cat_id'
          TestHarness.mm.subject = OpenStruct.new(:cow_id => 23, :cat_id => 33)
          @view.send(:component_path).should == 'cows/23/33'
        end

        it 'returns the path with the tokens substituted off the mm.subject hash' do
          TestHarness.mm.subject = {'cow_id' => 33}
          @view.send(:component_path).should == 'cows/33'

          TestHarness.mm.subject = {:cow_id => 33}
          @view.send(:component_path).should == 'cows/33'
        end

        it 'returns the path with the tokens substituted off the mm.subject hash' do
          FakeHarness::UiTest.component.path = 'cows/:cow_id/:cat_id'
          TestHarness.mm.subject = {'cow_id' => 33, :cat_id => 55}
          @view.send(:component_path).should == 'cows/33/55'
        end
      end
    end

    context 'Proc' do
      before :each do
        TestHarness.autoload
        FakeHarness::UiTest.component.path = lambda{|mm| 'cows/%s' % mm.cow_id }
        @view = FakeHarness::UiTest::UIView.new
      end

      it 'calls the proc to construct the path' do
        TestHarness.mm.cow_id = 23
        @view.send(:component_path).should == 'cows/23'
      end
    end

    context ':something_id' do
      before :each do
        TestHarness.autoload
        FakeHarness::UiTest.component.path = "cows/:cow_id"
        @view = FakeHarness::UiTest::UIView.new
      end

      it 'substitutes the something_id with mm.something_id' do
        TestHarness.mm.cow_id = 23
        @view.send(:component_path).should == 'cows/23'
      end

      it 'substitutes the something_id with mm.something.id' do
        TestHarness.mm.cow = OpenStruct.new(:id => 23)
        @view.send(:component_path).should == 'cows/23'
      end
    end
  end
end
