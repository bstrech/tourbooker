require 'spec_helper'

describe "users/rate" do
  before(:each) do
    @user = FactoryGirl.create(:user, is_done: true)
    assign(:user, @user)
  end

  it "renders rate user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", save_rating_user_path(@user.id, :token=>@user.token), "post" do
      assert_select "select#user_rating[name=?]", "user[rating]"
    end
  end
end
