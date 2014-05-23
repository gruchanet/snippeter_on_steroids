require 'spec_helper'

feature "Snippeter management" do

  scenario "User visits `recent snippets` page with no snippets" do
    visit snippets_path

    page.should have_content 'No snippets found.'
  end

  scenario "User visits `recent snippets` page, and founds 3 snippets", :js => true, :fill => true do
    @lang = FactoryGirl.create(:lang)
    3.times { @snippet = FactoryGirl.create(:snippet, lang: @lang) }

    visit snippets_path

    within(:css, 'tbody#snippets') {
      page.should have_content @snippet.description, :count => 3
      page.should have_no_content 'No snippets found.'
    }
  end

  feature "Logged user" do
    background do
      @userAuth = OmniAuth.config.mock_auth[:github]

      visit root_path
      click_link 'Login'
    end

    feature "after adding snippet with valid values" do
      background do
        @lang = FactoryGirl.create(:ruby_lang)
        @snippet = FactoryGirl.build(:snippet)

        click_link 'New Snippet'

        fill_in 'Snippet', :with => @snippet.snippet
        select @lang.name, from: 'Lang'
        fill_in 'Description', :with => @snippet.description
        click_button 'Add Snippet'
      end

      scenario "snippets page should show user avatar, label with username and link to his page in correct table row", :js => true do
        visit snippets_path

        within(:xpath, "//tbody[@id='snippets']/tr[@class='row-link']/td[@class='author-notion']/a[@class='profile-link' and @href='#{user_snippets_path(1)}']") do
          should have_css 'img.pic.img-circle'
          expect(find(:css, '.label-username')).to have_content @userAuth['info']['nickname']
        end
      end
    end
  end
end