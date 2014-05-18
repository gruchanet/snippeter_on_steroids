FactoryGirl.define do
  factory :snippet do
    snippet 'Code goes here'
    description 'It\'s just a test code'
    lang
  end

  factory :invalid_snippet, parent: :snippet do
    snippet ''
    description ''
    lang nil
  end
end