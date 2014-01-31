# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    ignore do
      done true
    end
    sequence(:email) {|n| "email#{n}@yopmail.com" }
    token "MyString"
    first_name {done ? "FirstName" : nil}
    last_name {done ? "LastName" : nil}
    phone {done ? "1-800-555-1234" : nil}
    ip_address {done ? "127.0.0.1" : nil}
    preferred_tour_date {done ? "2014-01-30" : nil}
    amn_pool {done ? true : false}
    amn_rec_room {done ? true : nil}
    amn_movie_theater false
    amn_doctor false
    amn_time_machine false
    rating {done ? 5 : nil}
    aasm_state {done ? "done" : "new"}
  end
end
