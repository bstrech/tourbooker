require 'spec_helper'

describe "users/activate" do
  before(:each) do
    @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "activating")
    assign(:user, @user)
  end

  it "renders activate user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", save_activation_user_path(@user.id, :token=>@user.token), "post" do
      assert_select "input#user_first_name[name=?]", "user[first_name]"
      assert_select "input#user_last_name[name=?]", "user[last_name]"
      assert_select "input#user_phone[name=?]", "user[phone]"
    end
  end
end
