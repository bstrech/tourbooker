require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :email => "MyString",
      :token => "MyString",
      :first_name => "MyString",
      :last_name => "MyString",
      :phone => "MyString",
      :ip_address => "MyString",
      :amn_pool => false,
      :amn_rec_room => false,
      :amn_movie_theater => false,
      :amn_doctor => false,
      :amn_time_machine => false,
      :rating => 1
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_path(@user), "post" do
      assert_select "input#user_email[name=?]", "user[email]"
      assert_select "input#user_token[name=?]", "user[token]"
      assert_select "input#user_first_name[name=?]", "user[first_name]"
      assert_select "input#user_last_name[name=?]", "user[last_name]"
      assert_select "input#user_phone[name=?]", "user[phone]"
      assert_select "input#user_ip_address[name=?]", "user[ip_address]"
      assert_select "input#user_amn_pool[name=?]", "user[amn_pool]"
      assert_select "input#user_amn_rec_room[name=?]", "user[amn_rec_room]"
      assert_select "input#user_amn_movie_theater[name=?]", "user[amn_movie_theater]"
      assert_select "input#user_amn_doctor[name=?]", "user[amn_doctor]"
      assert_select "input#user_amn_time_machine[name=?]", "user[amn_time_machine]"
      assert_select "input#user_rating[name=?]", "user[rating]"
    end
  end
end
