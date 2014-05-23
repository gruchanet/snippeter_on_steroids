FactoryGirl.define do
  factory :user do
    name 'chuck_tester'
    email 'chuck@test.it'
    provider 'github'
    uid '12345'
  end
end