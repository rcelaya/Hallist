# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profile do
    username "MyString"
    birth_date "2012-10-17"
    about "MyText"
    avatar "MyText"
  end
end
