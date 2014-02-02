require 'spec_helper'

describe "users/register" do
  before(:each) do
    @user = FactoryGirl.create(:user, is_done: true, aasm_state: "registering")
    assign(:user, @user)
  end

  it "renders register user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", save_registration_user_path(@user.id, :token=>@user.token), "post" do
      assert_select "input#user_preferred_tour_date[name=?]", "user[preferred_tour_date]"
      assert_select "input#user_amn_pool[name=?]", "user[amn_pool]"
      assert_select "input#user_amn_rec_room[name=?]", "user[amn_rec_room]"
      assert_select "input#user_amn_movie_theater[name=?]", "user[amn_movie_theater]"
      assert_select "input#user_amn_doctor[name=?]", "user[amn_doctor]"
      assert_select "input#user_amn_time_machine[name=?]", "user[amn_time_machine]"
    end
  end
end
