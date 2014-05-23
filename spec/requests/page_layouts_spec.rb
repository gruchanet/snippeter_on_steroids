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

  it "should have correct title" do
    should have_title("Snippeter App | About")
  end

  it "should have correct header" do
    page.should have_selector 'h1', text: 'Authors'
  end
end
