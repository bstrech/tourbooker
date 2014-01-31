require 'spec_helper'

describe "users/show" do
  before(:each) do
    @user = assign(:user, stub_model(User,
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
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    rendered.should match(/Token/)
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Phone/)
    rendered.should match(/Ip Address/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/false/)
    rendered.should match(/1/)
  end
end
