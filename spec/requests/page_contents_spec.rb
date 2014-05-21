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
  it { should have_link('Login', href: '/auth/github/') }
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

describe "Login on main page" do
  before :each do
    OmniAuth.config.mock_auth[:github]

    visit root_path
    click_link 'Login'
  end

  context "login through external account" do
    it "should return alert and put information into nav" do
      page.should have_content 'Signed in!'
      page.should have_content 'Logged as'
      page.should have_xpath '//img[@class="pic img-circle user-gravatar"]'
      page.should have_link 'Logout'
    end
  end

  context "adding new snipept" do
    context "with invalid values" do
      it "should return alert with 3 errors" do
        visit new_snippet_path
        click_button 'Add Snippet'
        page.should have_content '3 errors prohibited this snippet from being saved:'
        page.should have_content 'Snippet can\'t be blank'
        page.should have_content 'Lang can\'t be blank'
        page.should have_content 'Description can\'t be blank'
      end
    end

    context "with valid values" do
      before :each do
        @lang = FactoryGirl.create(:ruby_lang)
        @snippet = FactoryGirl.build(:snippet)

        visit new_snippet_path

        fill_in 'Snippet', :with => @snippet.snippet
        select @lang.name, from: 'Lang'
        fill_in 'Description', :with => @snippet.description
        click_button 'Add Snippet'
      end

      it "should return redirect to new snippet page" do
        expect(current_path).to eq(snippet_path(1))
      end

      it "should show alert with correct information" do
        expect(find(:css, '.alert.alert-info')).to have_content 'Snippet was successfully created.'
      end
    end
  end

  context "updating snippet" do
    before :each do
      @lang = FactoryGirl.create(:ruby_lang)
      @snippet = FactoryGirl.create(:snippet)

      visit edit_snippet_path(@snippet.id)
    end

    context "with invalid values" do
      before :all do
        @invalidSnippet = FactoryGirl.build(:invalid_snippet)
      end

      before :each do
        fill_in 'Snippet', :with => @invalidSnippet.snippet
        fill_in 'Description', :with => @invalidSnippet.description
        click_button 'Update Snippet'
      end

      it "should return redirect to edited snippet page" do
        expect(current_path).to eq(snippet_path(@snippet.id))
      end

      it "should return alert with 3 errors" do
        page.should have_content '2 errors prohibited this snippet from being saved:'
        page.should have_content 'Snippet can\'t be blank'
        page.should have_content 'Description can\'t be blank'
      end
    end

    context "with valid values" do
      before :all do
        @validSnippet = FactoryGirl.build(:snippet_to_update)
      end

      before :each do
        fill_in 'Snippet', :with => @validSnippet.snippet
        fill_in 'Description', :with => @validSnippet.description
        click_button 'Update Snippet'
      end

      it "should return redirect to edited snippet page" do
        expect(current_path).to eq(snippet_path(@snippet.id))
      end

      it "should show alert with correct information" do
        expect(find(:css, '.alert.alert-info')).to have_content 'Snippet was successfully updated.'
      end
    end
  end

  context "deleting snippet" do
    before :each do
      @lang = FactoryGirl.create(:ruby_lang)
      @snippet = FactoryGirl.create(:snippet)

      visit snippet_path(@snippet.id)

      find('.btn.btn-remove').click
    end

    it "should return redirect to snippets page" do
      expect(current_path).to eq(snippets_path)
    end

    it "should show alert with correct information" do
      expect(find(:css, '.alert.alert-info')).to have_content 'Snippet was successfully removed.'
    end
  end
end