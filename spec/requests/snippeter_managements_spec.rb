require 'spec_helper'

feature "Snippeter management" do

  scenario "User visits empty `recent snippets` page" do
    visit snippets_path

    page.should have_content('No snippets found.')
  end
end
