# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :collection do
    name "MyString"
    customer_id 1
    user_id 1
  end
end
