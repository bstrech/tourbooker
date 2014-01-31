require 'spec_helper'

describe User do
  describe "strip_attributes" do
    it "should strip leading and trailing whitespace from attributes" do
      user = User.create(:email=>" bs@test.com ", :first_name=>" Joe ", :last_name=>" User ", :phone=>" 1-800-555-4545 ")
      user.email.should == "bs@test.com"
      user.first_name.should == "Joe"
      user.last_name.should == "User"
      user.phone.should == "1-800-555-4545"
    end
  end
  describe "#validations" do
    describe "#email" do
      it "should require email" do
        u = User.new(:first_name => 'first', :last_name => 'Last')
        u.valid?.should be_false
        u.errors[:email].include?("can't be blank").should be_true
        u.errors.size.should == 1
      end
      it "should be unique" do

      end
    end
  end
  describe "#states" do

  end
end
