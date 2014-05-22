require 'spec_helper'

describe "About page layout" do
  before :each do
    visit about_path
  end

  it "has div with highlighted code with information about authors" do
    within(:css, 'div.highlight pre#json-team') do
      should have_css 'span.nt', :text => 'JSON_team', count: 1
      should have_css 'span.nt', :text => 'member', count: 4
      should have_css 'span.nt', :text => 'name', count: 4
      should have_css 'span.nt', :text => 'github_acc', count: 4
      should have_css 'span.s2'
    end
  end
end
