require 'spec_helper'

describe Snippet do

  describe "#new" do

    it "returns a new Snippet object" do
      @snippet = Snippet.new
      @snippet.should be_an_instance_of Snippet
    end

    it "returns a new Snippet object with picked parameter" do
      @snippet = Snippet.new :description => 'bla', :snippet => 'test'

      @snippet.description.should eq ('bla')
      @snippet.snippet.should eq ('test')
    end

    it "is invalid without code & description" do
      FactoryGirl.build(:invalid_snippet).should_not be_valid
    end

  end

end
