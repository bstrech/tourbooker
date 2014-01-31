require 'spec_helper'

describe User do
  describe "strip_attributes" do
    it "should strip leading and trailing whitespace from attributes" do
      user = User.create(:email=>" bs@yopmail.com ", :first_name=>" Joe ", :last_name=>" User ", :phone=>" 1-800-555-4545 ")
      user.email.should == "bs@yopmail.com"
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
      it "should send back the taken message when email is not unique" do
        joeuser = FactoryGirl.create(:user)
        user = User.new(:first_name=>'new', :last_name=>'user', :email=>joeuser.email.upcase)
        user.valid?.should be_false
        user.errors[:email].first.should == I18n.t("activerecord.errors.models.user.attributes.email.taken")
      end
      describe "validates_format_of email" do
        before do
          @user = FactoryGirl.create(:user)
        end
        it "should not allow email value of 'test@test.com test1@test.com'" do
          @user.email = "test@test.com test1@test.com"
          @user.valid?.should be_false
          @user.errors[:email].first.should == I18n.t('activerecord.errors.models.user.attributes.email.invalid')
        end
      end
    end
  end
  describe "#states" do

  end
  describe "#callbacks" do
    it "should save emails in lowercase on create" do
      user = User.new(:first_name=>'new', :last_name=>'user')
      user.email = 'TestUser@MyCompany.com'
      user.save.should be_true
      user.reload.email.should == 'testuser@mycompany.com'
    end
    it "should save emails in lowercase on update" do
      user = FactoryGirl.create(:user)
      user.new_record?.should be_false
      user.update_attributes(:email=>'TestUser@MyCompany.com')
      user.email.should == 'testuser@mycompany.com'
    end
  end
end
