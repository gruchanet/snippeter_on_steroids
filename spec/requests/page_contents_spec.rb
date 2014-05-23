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

  it "should have correct title" do
    should have_title("Snippeter App")
  end

  it "should have correct header" do
    page.should have_selector 'h1', text: 'Welcome to Snippeter'
  end

end

describe "Main page" do
  before { visit root_path }

  it "has valid `new snippet` button" do
    within(:css, '.container .jumbotron') do
      expect( find(:css, '.btn.btn-primary.btn-lg') ).to have_content 'Snippet NOW »'
      should have_link 'Snippet NOW »', href: 'snippets/new'
    end
  end
  it "has valid `Filters` button" do
    click_link 'Search'
    expect( find(:css, '.btn.btn-primary') ).to have_content 'Filters'
    should have_selector 'span'
  end

  it "has valid `new snippet` button" do
    click_link 'Recent Snippets'
    expect( find(:css, '.btn.btn-add') ).to have_content 'New Snippet'
    should have_link 'New Snippet', href: '/snippets/new'
 
  end

  it "vailid title after multiclicking" do
    100.times do
      click_link 'Snippets'
      click_link 'Recent Snippets'
      click_link 'Authors'
      click_link 'Search'
    end
    should have_title("Snippeter App | Search snippets")
    page.should have_selector 'h1', text: 'Search snippets'
  end
  it "random link clicking" do
    100.times do
      click_link ['Snippets','Recent Snippets','Authors','Search'].sample
    end
  end
  it "message log in" do
    click_link 'Search'
    click_button 'Filters'
    click_link 'New Snippet'
    page.should have_selector '.alert', text: 'Please log in'
  end
  it "message log in" do
    click_link 'Snippet NOW »'
    page.should have_selector '.alert', text: 'Please log in'
  end

end

describe "Login on main page" do
  before :each do
    OmniAuth.config.mock_auth[:github]
    visit root_path
    click_link 'Login'
  end

  context "login through external account" do
    it "should return alert and put corrent informations into nav" do
      page.should have_content 'Signed in!'
      page.should have_content 'Logged as'
      page.should have_xpath '//a[@href="http://github.com/chuck_tester" and @target="_blank"]/img[@class="pic img-circle user-gravatar"]'
      page.should have_link 'Logout'
    end
  end

  context "adding new snipept" do
    context "with invalid values" do
      before :each do
        visit new_snippet_path
        click_button 'Add Snippet'
      end
      it "should return alert with 3 errors" do
        page.should have_content '3 errors prohibited this snippet from being saved:'
      end
      it "should return Snippet errors" do
        page.should have_content 'Snippet can\'t be blank'
      end
      it "should return Lang errors" do
        page.should have_content 'Lang can\'t be blank'
      end
      it "should return Description errors" do
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

      it "should return alert with 2 errors" do
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

  it "should corectly relogin" do
    click_link 'Logout'
    click_link 'Login'
    page.should have_content 'Signed in!'
  end

  it "should corectly relogin" do
    click_link 'Logout'
    click_link 'Login'
    page.should have_content 'Signed in!'
  end

  it "has valid `new snippet` button" do
    visit root_path

    within(:css, '.container .jumbotron') do
      expect( find(:css, '.btn.btn-primary.btn-lg') ).to have_content 'Snippet NOW »'
      should have_link 'Snippet NOW »', href: 'snippets/new'
    end
  end

  it "has valid `Filters` button" do
    click_link 'Search'
    expect( find(:css, '.btn.btn-primary') ).to have_content 'Filters'
    should have_selector 'span'
  end

  it "has valid `new snippet` button" do
    click_link 'Recent Snippets'
    expect( find(:css, '.btn.btn-add') ).to have_content 'New Snippet'
    should have_link 'New Snippet', href: '/snippets/new'
 
  end

  it "has valid title after multiclicking" do
    20.times do
      click_link 'Snippets'
      click_link 'Recent Snippets'
      click_link 'Authors'
      click_link 'Search'
    end
    should have_title("Snippeter App | Search snippets")
    page.should have_selector 'h1', text: 'Search snippets'
  end

  it "random link clicking" do
    20.times do
      click_link ['Snippets','Recent Snippets','Authors','Search'].sample
    end
  end

  context "Clicking on `New Snippet` button" do
    it "should render alert with message `Please log in first.`" do
      click_link 'New Snippet'
      page.should_not have_selector '.alert'
    end
  end

  context "Clicking on `Snippet NOW »` button" do
    it "should render alert with message `Please log in first.`" do
      visit root_path

      click_link 'Snippet NOW »'
      page.should_not have_selector '.alert'
    end
  end

  context "and logout from account" do
    before :each do
      click_link 'Logout'
    end

    it "should render alert with correct information" do
      expect(find(:css, '.alert.alert-info')).to have_content 'Signed out!'
      page.should_not have_content 'Logged as'
      page.should_not have_xpath '//a[@href="http://github.com/chuck_tester" and @target="_blank"]/img[@class="pic img-circle user-gravatar"]'
      page.should have_link 'Login'
    end
  end

  context "New snippet page" do
    before { visit('/snippets/new') }

    it "should have page title" do
      within(:css, '.container .page-header') {
        expect has_content?("New snippet")
      }
    end

    it "should have back button" do
      within(:css, '.container .page-header') {
        expect(find(:css, '.btn.btn-default')). has_content? 'Back'
      }
    end
  end
end

describe "Recent snippet" do
  before :each do
    OmniAuth.config.mock_auth[:github]

    visit root_path
    click_link 'Login'
  end

  before { visit('/snippets') }

  it "should have page title" do
    within(:css, '.container .page-header') {
      expect has_content?("Recent snippets")
    }
  end

  it "should have add new snippet button" do
    within(:css, '.container .page-header') {
      expect(find(:css, '.btn')). has_content? 'New Snippet'
    }
  end

  it "should have paggination" do
    within(:css, '.container #static-pagination') do
      expect has_selector?("a", text: "← Previous")
      expect has_selector?("a", text: "Next →")
    end
  end
end
