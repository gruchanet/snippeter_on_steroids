require 'spec_helper'

describe Lang do

  it "returns a new Snippet object" do
    @lang = Lang.new
    @lang.should be_an_instance_of Lang
  end

  it "returns a new Snippet object with picked parameter" do
    @lang = Lang.new :name => 'Ruby', :value => 'ruby', :order_type => 1

    @lang.name.should eq 'Ruby'
    @lang.value.should eq 'ruby'
    @lang.order_type.should eq 1
  end

  it "is invalid without name & value" do
    FactoryGirl.build(:invalid_lang).should_not be_valid
  end

end
