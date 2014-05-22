require 'spec_helper'

feature "Snippeter management" do

  scenario "User visits `recent snippets` page with no snippets" do
    visit snippets_path

    page.should have_content 'No snippets found.'
  end

#  scenario "User visits `recent snippets` page, and founds 3 snippets", :js => true, :fill => true do
#    @lang = FactoryGirl.create(:lang)
#    3.times { @snippet = FactoryGirl.create(:snippet, lang: @lang) }

#    visit snippets_path

#    within(:css, 'tbody#snippets') {
#      page.should have_content @snippet.description, :count => 3
#      page.should have_no_content 'No snippets found.'
#    }
#  end


end
