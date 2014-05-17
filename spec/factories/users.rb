FactoryGirl.define do
  factory :user do
    name 'Test'
    provider 'github'
    uid '111'
  end
end