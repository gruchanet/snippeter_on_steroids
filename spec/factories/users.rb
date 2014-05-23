FactoryGirl.define do
  factory :user do
    name 'chuck_tester'
    email 'chuck@test.it'
    provider 'github'
    uid '12345'
  end

  factory :other_user, :parent => :user do
    name 'chuck_the_tester'
    email 'the_chuck@test.it'
    provider 'github'
    uid '54321'
  end
end