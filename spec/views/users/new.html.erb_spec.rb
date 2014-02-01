require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, FactoryGirl.build(:user, is_done: false))
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", users_path, "post" do
      assert_select "input#user_email[name=?]", "user[email]"
    end
  end
end
