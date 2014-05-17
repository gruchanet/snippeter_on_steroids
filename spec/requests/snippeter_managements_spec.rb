require 'spec_helper'

feature "Snippeter management" do

  scenario "User visits empty `recent snippets` page" do
    visit '/snippets'
    
    expect(page).to have_content 'No snippets found.'
  end
end
