require 'spec_helper'

describe UsersHelper do
  context "Render snippets count in label" do
    it "should have correct class & count" do
      count = 10

      expect(render_count count).to eq "<span class=\"label label-info label-total\">#{count}</span>"
    end

    it "should have correct class & count" do
      count = 1000

      expect(render_count count).to eq "<span class=\"label label-danger label-total\">999+</span>"
    end
  end
end
