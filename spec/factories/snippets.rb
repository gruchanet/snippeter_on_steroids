FactoryGirl.define do
  factory :snippet do
    snippet "snippet",
    description "dupa",
    lang_id  { |instance| Factory(:lang) }
  end
end