require 'spec_helper'

describe "Menu content" do
  it "is valid on root page" do
    visit root_path

    within(:css, '.navbar') {
      within(:css, '.navbar-header') {
        page.should have_content('Snippeter')
      }

      find(:xpath, '//ul[@class="nav navbar-nav"][1]/li[1]/a').should have_text('Recent Snippets')
      find(:xpath, '//ul[@class="nav navbar-nav"][1]/li[2]/a').should have_text('Search')
      find(:css, '.nav.navbar-nav.navbar-right').should have_content('Authors')
    }
  end
end
