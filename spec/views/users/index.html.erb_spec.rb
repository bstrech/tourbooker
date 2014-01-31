require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :email => "Email",
        :token => "Token",
        :first_name => "First Name",
        :last_name => "Last Name",
        :phone => "Phone",
        :ip_address => "Ip Address",
        :amn_pool => false,
        :amn_rec_room => false,
        :amn_movie_theater => false,
        :amn_doctor => false,
        :amn_time_machine => false,
        :rating => 1
      ),
      stub_model(User,
        :email => "Email",
        :token => "Token",
        :first_name => "First Name",
        :last_name => "Last Name",
        :phone => "Phone",
        :ip_address => "Ip Address",
        :amn_pool => false,
        :amn_rec_room => false,
        :amn_movie_theater => false,
        :amn_doctor => false,
        :amn_time_machine => false,
        :rating => 1
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Ip Address".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 10
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
