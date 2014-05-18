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

  end

end
