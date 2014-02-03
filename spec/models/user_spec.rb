require 'spec_helper'

describe User do
  describe "strip_attributes" do
    it "should strip leading and trailing whitespace from attributes" do
      user = FactoryGirl.create(:user, :email=>" bs@yopmail.com ", :first_name=>" Joe ", :last_name=>" User ", :phone=>" 1-800-555-4545 ")
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
    describe "#token" do
      it "should require token" do
        u = User.new(:first_name => 'first', :last_name => 'Last')
        u.token = nil
        u.valid?.should be_false
        u.errors[:token].include?("can't be blank").should be_true
      end
    end
    context "when the user is in state of new" do
      before do
       @u = FactoryGirl.build(:user, is_done: false)
      end
      it "shouldn't require first_name, last_name, phone" do
        @u.valid?
        @u.errors[:first_name].should be_empty
        @u.errors[:last_name].should be_empty
        @u.errors[:phone].should be_empty
      end
      it "shouldn't require preferred_tour_date, ip_address" do
        @u.valid?
        @u.errors[:preferred_tour_date].should be_empty
        @u.errors[:ip_address].should be_empty
      end
      it "shouldn't require rating" do
        @u.valid?
        @u.errors[:rating].should be_empty
      end
    end
    context "when user is in the state of activating" do
      before do
        @u = FactoryGirl.build(:user, is_done: false, aasm_state: "activating")
      end
      it "should require first_name, last_name, phone" do
        @u.valid?
        @u.errors[:first_name].include?("can't be blank").should be_true
        @u.errors[:last_name].include?("can't be blank").should be_true
        @u.errors[:phone].include?("can't be blank").should be_true
      end
      it "shouldn't require preferred_tour_date, ip_address" do
        @u.valid?
        @u.errors[:preferred_tour_date].should be_empty
        @u.errors[:ip_address].should be_empty
      end
      it "shouldn't require rating" do
        @u.valid?
        @u.errors[:rating].should be_empty
      end
    end
    context "when user is in the state of registering" do
      before do
        @u = FactoryGirl.build(:user, is_done: false, aasm_state: "registering")
      end
      it "should require first_name, last_name, phone" do
        @u.valid?
        @u.errors[:first_name].include?("can't be blank").should be_true
        @u.errors[:last_name].include?("can't be blank").should be_true
        @u.errors[:phone].include?("can't be blank").should be_true
      end
      it "should require preferred_tour_date, ip_address" do
        @u.valid?
        @u.errors[:preferred_tour_date].include?("can't be blank").should be_true
        @u.errors[:ip_address].include?("can't be blank").should be_true
      end
      it "shouldn't require rating" do
        @u.valid?
        @u.errors[:rating].should be_empty
      end
    end
    context "when user is in the state of done" do
      before do
        @u = FactoryGirl.build(:user, is_done: true)
      end
      it "should require first_name, last_name, phone" do
        @u.first_name = nil
        @u.last_name = nil
        @u.phone = nil
        @u.valid?
        @u.errors[:first_name].include?("can't be blank").should be_true
        @u.errors[:last_name].include?("can't be blank").should be_true
        @u.errors[:phone].include?("can't be blank").should be_true
      end
      it "should require preferred_tour_date, ip_address" do
        @u.preferred_tour_date = nil
        @u.ip_address = nil
        @u.valid?
        @u.errors[:preferred_tour_date].include?("can't be blank").should be_true
        @u.errors[:ip_address].include?("can't be blank").should be_true
      end
      it "shouldn't require rating" do
        @u.rating = nil
        @u.valid?
        @u.errors[:rating].include?("can't be blank").should be_false
      end
      it "should require rating is in the right range" do
        (0..6).each do |n|
          @u.rating = n
          @u.valid?
          if (1..5).include?(@u.rating)
            @u.errors[:rating].should be_empty
          else
            @u.errors[:rating].include?("must be 1-5.").should be_true
          end
        end
      end
    end
  end
  describe "#states" do
    it "should set the state as new when initializing" do
      user = User.new(:first_name=>'new', :last_name=>'user')
      user.aasm_state.should =="new"
      user.new?.should be_true
    end
    describe "transitions" do
      it "should set the right states when transitioning" do
        user = FactoryGirl.build(:user, is_done:false)
        user.aasm_state.should =="new"
        user.new?.should be_true
        user.may_activate?.should be_true
        user.may_register?.should be_false
        user.may_finish?.should be_false

        user.activate
        user.activating?.should be_true
        user.may_activate?.should be_false
        user.may_register?.should be_true
        user.may_finish?.should be_false

        user.register
        user.registering?.should be_true
        user.may_activate?.should be_false
        user.may_register?.should be_false
        user.may_finish?.should be_true

        user.finish
        user.done?.should be_true
        user.may_activate?.should be_false
        user.may_register?.should be_false
        user.may_finish?.should be_false
      end
    end
  end
  describe "#callbacks" do
    describe "#before_save" do
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
      it "should create a token when the user is new" do
        user = User.new(:first_name=>'new', :last_name=>'user', :email=>'TestUser@MyCompany.com')
        user.token.should_not be_nil
      end
    end
    describe "#after_create" do
      it "should call send_create_email" do
        user = User.new(:first_name=>'new', :last_name=>'user', :email=>'TestUser@MyCompany.com')
        user.should_receive(:send_create_email)
        user.save
      end
    end
    describe "#after_update" do
      it "should not call send_create_email" do
        user = User.create(:first_name=>'new', :last_name=>'user', :email=>'TestUser@MyCompany.com')
        user.should_not_receive(:send_create_email)
        user.update_attributes(:first_name=>"update").should be_true
      end
    end
    describe "#after_save" do
      before do
        @user = FactoryGirl.create(:user, is_done: true, aasm_state: "new")
      end
      context "when aasm_state doesn't change and the state is done" do
        before do
          @user.update_attributes(:aasm_state=>"done").should be_true
        end
        it "shouldn't call send_tour_scheduled and new_tour_scheduled " do
           @user.should_not_receive(:send_tour_scheduled)
           @user.should_not_receive(:send_new_tour_scheduled)
           @user.update_attributes(:first_name=>"new_name").should be_true
        end
      end
      context "when aasm_state changes and the new state is new" do
        it "shouldn't call send_tour_scheduled and new_tour_scheduled " do
          @user = FactoryGirl.build(:user, is_done: true, aasm_state: "new")
          @user.should_not_receive(:send_tour_scheduled)
          @user.should_not_receive(:send_new_tour_scheduled)
          @user.save.should be_true
        end
      end
      context "when aasm_state changes and the new state is activating" do
        it "shouldn't call send_tour_scheduled and new_tour_scheduled " do
          @user.should_not_receive(:send_tour_scheduled)
          @user.should_not_receive(:send_new_tour_scheduled)
          @user.update_attributes(:first_name=>"new_name", :aasm_state=>"activating").should be_true
        end
      end
      context "when aasm_state changes and the new state is registering" do
        it "shouldn't call send_tour_scheduled and new_tour_scheduled " do
          @user.should_not_receive(:send_tour_scheduled)
          @user.should_not_receive(:send_new_tour_scheduled)
          @user.update_attributes(:first_name=>"new_name", :aasm_state=>"registering").should be_true
        end
      end
      context "when aasm_state changes and the new state is done" do
        it "should call send_tour_scheduled and new_tour_scheduled " do
          @user.should_receive(:send_tour_scheduled)
          @user.should_receive(:send_new_tour_scheduled)
          @user.update_attributes(:first_name=>"new_name", :aasm_state=>"done").should be_true
        end
      end
    end
  end
  describe "#send_tour_scheduled" do
    before do
      @user = FactoryGirl.create(:user, is_done: true)
    end
    it "should deliver the tour_schedule_confirmation" do
      @user.send_tour_scheduled
      email = ActionMailer::Base.deliveries.last
      email.from.should == ["donotreply@example.com"]
      email.to.should == [@user.email]
      email.subject.should == I18n.t("action_mailer.tour_scheduled_confirmation.subject")
    end
  end
  describe "#send_new_tour_scheduled" do
    before do
      @user = FactoryGirl.create(:user, is_done: true)
    end
    it "should deliver the new_tour_scheduled" do
      @user.send_new_tour_scheduled
      email = ActionMailer::Base.deliveries.last
      email.from.should == ["donotreply@example.com"]
      email.to.should == ["tours@example.com"]
      email.subject.should == I18n.t("action_mailer.new_tour_scheduled.subject")
    end
  end
  describe "#send_create_email" do
    before do
      @user = FactoryGirl.create(:user, is_done: false)
    end
    it "should deliver email" do
      @user.send_create_email
      email = ActionMailer::Base.deliveries.last
      email.from.should == ["donotreply@example.com"]
      email.to.should == [@user.email]
      email.subject.should == I18n.t("action_mailer.activate_user.subject")
    end
  end
end
