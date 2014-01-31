# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    ignore do
      is_done true
      is_rating false
    end
    sequence(:email) {|n| "email#{n}@yopmail.com" }
    token "MyString"
    first_name {(is_done||is_rating) ? "FirstName" : nil}
    last_name {(is_done||is_rating) ? "LastName" : nil}
    phone {(is_done||is_rating) ? "1-800-555-1234" : nil}
    ip_address {(is_done||is_rating) ? "127.0.0.1" : nil}
    preferred_tour_date {(is_done||is_rating) ? "2014-01-30" : nil}
    amn_pool {is_done ? true : false}
    amn_rec_room {is_done ? true : nil}
    amn_movie_theater false
    amn_doctor false
    amn_time_machine false
    rating {is_done ? 5 : nil}
    aasm_state {is_done ? "done" : "new"}
  end
end
