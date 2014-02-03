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
    email.subject.should == I18n.t("action_mailer.activate_user.subject")
    end
  end
  describe "tour_scheduled_confirmation mailer" do
    before do
      @user = FactoryGirl.create(:user, is_done: true)
    end
    it "should have all the right stuff" do
      email = UserMailer.tour_scheduled_confirmation(@user).deliver
      ActionMailer::Base.deliveries.empty?.should be_false

      # Test the body of the sent email contains what we expect it to
      email.from.should == ["donotreply@example.com"]
      email.to.should == [@user.email]
      email.subject.should == I18n.t("action_mailer.tour_scheduled_confirmation.subject")
    end
  end

  describe "new_tour_scheduled mailer" do
    before do
      @user = FactoryGirl.create(:user, is_done: true)
    end
    it "should have all the right stuff" do
      email = UserMailer.new_tour_scheduled(@user).deliver
      ActionMailer::Base.deliveries.empty?.should be_false

      # Test the body of the sent email contains what we expect it to
      email.from.should == ["donotreply@example.com"]
      email.to.should == ["tours@example.com"]
      email.subject.should == I18n.t("action_mailer.new_tour_scheduled.subject")
    end
  end
end
