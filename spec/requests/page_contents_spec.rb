require 'spec_helper'

describe "Menu content" do
  before { visit root_path }

  it "has valid position on root page" do
    within(:css, '.navbar') {
      within(:css, '.navbar-header') {
        page.should have_content('Snippeter')
      }

      find(:xpath, '//ul[@class="nav navbar-nav"][1]/li[1]/a').should have_text('Recent Snippets')
      find(:xpath, '//ul[@class="nav navbar-nav"][1]/li[2]/a').should have_text('Search')
      find(:css, '.nav.navbar-nav.navbar-right').should have_content('Authors')
    }
  end

  it { should have_link('Recent Snippets', href: snippets_path) }
  it { should have_link('Search', href: snippets_search_path) }
  it { should have_link('Authors', href: about_path) }
end

describe "Main page" do
  before { visit root_path }

  it "has valid `new snippet` button" do
    within(:css, '.container .jumbotron') do
      expect( find(:css, '.btn.btn-primary.btn-lg') ).to have_content 'Snippet NOW »'
      should have_link 'Snippet NOW »', href: 'snippets/new'
    end
  end
end
