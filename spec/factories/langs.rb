FactoryGirl.define do
  factory :lang do
    name 'PHP'
    value 'php'
    order_type 1
  end

  factory :ruby_lang, :parent => :lang do
    name 'Ruby'
    value 'ruby'
  end

  factory :invalid_lang, :parent => :lang do
    name ''
    value ''
  end
end