FactoryGirl.define do
  factory :snippet do
    snippet 'Code goes here'
    description 'It\'s just a test code'
    lang
    user
  end

  factory :snippet_to_update, :parent => :snippet do
    snippet 'Updated code'
    description 'It\'s just a updated code'
  end

  factory :invalid_snippet, :parent => :snippet do
    snippet ''
    description ''
  end
end