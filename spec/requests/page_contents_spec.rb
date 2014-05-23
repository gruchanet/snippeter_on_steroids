require 'spec_helper'

describe "Menu content" do
  before { visit root_path }

  it "has valid position on root page" do
    within(:css, '.navbar') {
      within(:css, '.navbar-header') {
        page.should have_content('Snippeter')
      }

      find(:xpath, '//ul[@class="nav navbar-nav"][1]/li[1]/a').should have_text('Snippets')
      find(:xpath, '//ul[@class="nav navbar-nav"][1]/li[2]/a').should have_text('Users')
      find(:xpath, '//ul[@class="nav navbar-nav"][1]/li[3]/a').should have_text('Search')
      find(:css, '.nav.navbar-nav.navbar-right').should have_content('Authors')
    }
  end

  it "should have link to home page on all page" do
    expect( find(:css, '.navbar .navbar-header') ).to have_content 'Snippeter'
      should have_link 'Snippeter', href: '/'
  end

  it { should have_link('Snippets', href: snippets_path) }
  it { should have_link('Users', href: users_path) }
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

  it "has valid `login NOW` button" do
    within(:css, '.container .jumbotron') do
      expect(page).to have_link 'NOW »', href: '/auth/github'
    end
  end

  it "should have welcome description" do
    within(:css, '.container .jumbotron') do
      should have_selector("h2", text: "Snippeter just for YOU!")
    end
  end

  it "should have title in h1 selector" do
    visit root_path
    page.should have_selector("h1", text: "Welcome to Snippeter")
  end
end

describe "Search page" do
  before :each do
    visit snippets_search_path
  end

  it "should have valid `Filters` button" do
    expect( find(:css, '.btn.btn-primary') ).to have_content 'Filters'
    should have_selector 'span'
  end
end

describe "Login on main page" do
  before :each do
    @userAuth = OmniAuth.config.mock_auth[:github]
    @user = FactoryGirl.create(:user)

    visit root_path
    click_link 'Login'
  end

  it "should correctly relogin" do
    click_link 'Logout'
    click_link 'Login'
    page.should have_content 'Signed in!'
  end

  it "has valid title after multiclicking" do
    20.times do
      click_link 'Snippets'
      click_link 'Users'
      click_link 'Authors'
      click_link 'Search'
    end
    should have_title("Snippeter App | Search snippets")
    page.should have_selector 'h1', text: 'Search snippets'
  end

  it "random link clicking" do
    20.times do
      click_link ['Snippets','Users','Authors','Search'].sample
    end
  end

  context "Go to main page" do
    before :each do
      visit root_path
    end

    it "should have valid `new snippet` button" do
      within(:css, '.container .jumbotron') do
        expect(page).to have_link 'Snippet NOW »', :href => new_snippet_path
      end
    end
  end

  context "login through external account" do
    it "should render alert and put corrent informations into nav" do
      expect(find(:css, '.alert.alert-info')).to have_content 'Signed in!'
      page.should have_content 'Logged as'
      page.should have_xpath "//a[@href='#{user_snippets_path 1}']/img[@class='pic img-circle user-gravatar']"
      page.should have_link 'Logout'
    end
  end

  context "adding new snippet" do
    context "with invalid values" do
      before :each do
        visit new_snippet_path
        click_button 'Add Snippet'
      end

      it "should return alert with 3 errors" do
        page.should have_content '3 errors prohibited this snippet from being saved:'
      end

      it "should return Snippet error" do
        page.should have_content 'Snippet can\'t be blank'
      end

      it "should return Lang error" do
        page.should have_content 'Lang can\'t be blank'
      end

      it "should return Description error" do
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

      it "should render alert with correct information" do
        expect(find(:css, '.alert.alert-info')).to have_content 'Snippet was successfully created.'
      end
    end
  end

  context "updating snippet" do
    before :each do
      @lang = FactoryGirl.create(:ruby_lang)
      @snippet = FactoryGirl.create(:snippet, :user_id => 1)

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

      it "should render alert with correct information" do
        expect(find(:css, '.alert.alert-info')).to have_content 'Snippet was successfully updated.'
      end
    end
  end

  context "deleting snippet" do
    before :each do
      @lang = FactoryGirl.create(:ruby_lang)
      @snippet = FactoryGirl.create(:snippet, :user_id => 1)

      visit snippet_path(@snippet.id)

      find('.btn.btn-remove').click
    end

    it "should return redirect to snippets page" do
      expect(current_path).to eq(snippets_path)
    end

    it "should render alert with correct information" do
      expect(find(:css, '.alert.alert-info')).to have_content 'Snippet was successfully removed.'
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

  it "should have pagination" do
    within(:css, '.container #static-pagination') do
    	expect has_selector?("a", text: "← Previous")
	    expect has_selector?("a", text: "Next →")
    end
  end
end
