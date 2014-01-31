# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "email#{n}@yopmail.com" }
    token "MyString"
    first_name "MyString"
    last_name "MyString"
    phone "MyString"
    ip_address "MyString"
    preferred_tour_date "2014-01-30"
    amn_pool false
    amn_rec_room false
    amn_movie_theater false
    amn_doctor false
    amn_time_machine false
    rating 1
  end
end
