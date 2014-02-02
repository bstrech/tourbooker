require "spec_helper"

describe UserMailer do

  describe "create_user mailer" do
    before do
      @user = FactoryGirl.create(:user, is_done: false)
    end
    it "should have all the right stuff" do
    email = UserMailer.create_user(@user).deliver
    ActionMailer::Base.deliveries.empty?.should be_false

    # Test the body of the sent email contains what we expect it to
    email.from.should == ["donotreply@example.com"]
    email.to.should == [@user.email]
    email.subject.should == I18n.t("actionmailer.activate_user.subject")
    end
  end
end
