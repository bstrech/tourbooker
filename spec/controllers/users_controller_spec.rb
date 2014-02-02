require 'spec_helper'

describe UsersController do

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }


  describe "GET new" do
    it "assigns a new user as @user" do
      get :new, {}, valid_session
      assigns(:user).should be_a_new(User)
    end
  end


  describe "POST create" do
    describe "with valid params of a user email that doesn't exist" do
      it "creates a new User when the email is not found" do
        expect {
          post :create, {:user => {:email=>FactoryGirl.generate(:email)}}, valid_session
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, {:user => {:email=>FactoryGirl.generate(:email)}}, valid_session
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to the success page" do
        email = FactoryGirl.generate(:email)
        post :create, {:user => {:email=>email}}, valid_session
        user = User.find_by_email(email)
        response.should redirect_to(create_success_user_path(user, :token=>user.token))
      end

      it "assigns the right notice message" do
        post :create, {:user => {:email=>FactoryGirl.generate(:email)}}, valid_session
        request.flash[:notice].should == I18n.t("views.success.create_success")
      end

    end
    describe "with valid params of a user email that does exist" do
      before do
        @user = FactoryGirl.create(:user, is_done: false)
      end
      it "doesn't create a new User when the email is found" do
        expect {
          post :create, {:user => {:email=>@user.email}}, valid_session
        }.not_to change(User, :count).by(1)
      end

      it "assigns the found user as @user" do
        post :create, {:user => {:email=>@user.email}}, valid_session
        assigns(:user).should be_a(User)
        assigns(:user).should == @user
      end

      it "assigns the right notice message" do
        post :create, {:user => {:email=>@user.email}}, valid_session
        request.flash[:notice].should == I18n.t("views.success.found_success_html", :link=>resend_activation_user_path(@user, :token=>@user.token))
      end

      it "redirects to the success page" do
        post :create, {:user => {:email=>@user.email}}, valid_session
        response.should redirect_to(create_success_user_path(@user, :token=>@user.token))
      end
    end
    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => { :email => "invalid value" }}, valid_session
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => { :email => "invalid value" }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      xit "updates the requested user" do
        user = User.create! valid_attributes
        # Assuming there are no other users in the database, this
        # specifies that the User created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        User.any_instance.should_receive(:update_attributes).with({ "email" => "MyString" })
        put :update, {:id => user.to_param, :user => { "email" => "MyString" }}, valid_session
      end

      xit "assigns the requested user as @user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        assigns(:user).should eq(user)
      end

      xit "redirects to the user" do
        user = User.create! valid_attributes
        put :update, {:id => user.to_param, :user => valid_attributes}, valid_session
        response.should redirect_to(user)
      end
    end

    describe "with invalid params" do
      xit "assigns the user as @user" do
        user = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => user.to_param, :user => { "email" => "invalid value" }}, valid_session
        assigns(:user).should eq(user)
      end

      xit "re-renders the 'edit' template" do
        user = User.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        put :update, {:id => user.to_param, :user => { "email" => "invalid value" }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "GET create_success" do
    it "should redirect to root if user id is not found" do
      get :create_success, {:id=>0}, valid_session
      response.should redirect_to(root_path())
    end
    it "should redirect to root if user is found but token doesn't match" do
      @user = FactoryGirl.create(:user, is_done: false)
      get :create_success, {:id=>@user.id, :token=>"#{@user.token}r"}, valid_session
      response.should redirect_to(root_path())
    end
    context "when user is found" do
      before do
        @user = FactoryGirl.create(:user, is_done: false)
      end
      it "should render the create_success template" do
        get :create_success, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should render_template('users/create_success')
      end
    end
  end

  describe "GET resend_activation" do
    it "should redirect to root if user is not found" do
      get :resend_activation, {:id=>0}, valid_session
      response.should redirect_to(root_path())
    end
    it "should redirect to root if user is found but token doesn't match" do
      @user = FactoryGirl.create(:user, is_done: false)
      get :resend_activation, {:id=>@user.id, :token=>"#{@user.token}r"}, valid_session
      response.should redirect_to(root_path())
    end
    context "when user is found" do
      before do
        @user = FactoryGirl.create(:user, is_done: false)
      end
      it "should redirect to create_success if user is found" do
        get :resend_activation, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(create_success_user_path(@user, :token=>@user.token))
      end
      it "assigns the right notice message" do
        get :resend_activation, {:id=>@user.id, :token=>@user.token}, valid_session
        request.flash[:notice].should == I18n.t("views.success.create_success")
      end
      it "should call send_create_email on the user" do
        User.should_receive(:find_by_id_and_token).with(@user.id.to_s, @user.token).and_return(@user)
        @user.should_receive(:send_create_email)
        get :resend_activation, {:id=>@user.id, :token=>@user.token}, valid_session
      end
    end
  end
  describe "GET activate" do
    it "should redirect to root if user id is not found" do
      get :activate, {:id=>0}, valid_session
      response.should redirect_to(root_path())
    end
    it "should redirect to root if user is found but token doesn't match" do
      @user = FactoryGirl.create(:user, is_done: false)
      get :activate, {:id=>@user.id, :token=>"#{@user.token}r"}, valid_session
      response.should redirect_to(root_path())
    end
    context "when user is found" do
      before do
        @user = FactoryGirl.create(:user, is_done: false)
      end
      it "should render the activate template" do
        get :activate, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should render_template('users/activate')
      end
      it "should assign user and aasm_state should be 'activate'" do
        get :activate, {:id=>@user.id, :token=>@user.token}, valid_session
        user = assigns[:user]
        user.id.should == @user.id
        user.activating?.should be_true
      end
      xit "should redirect to rating when user state is done" do

      end
    end
  end
  describe "GET register" do
    it "should redirect to root if user id is not found" do
      get :register, {:id=>0}, valid_session
      response.should redirect_to(root_path())
    end
    it "should redirect to root if user is found but token doesn't match" do
      @user = FactoryGirl.create(:user, is_done: false)
      get :register, {:id=>@user.id, :token=>"#{@user.token}r"}, valid_session
      response.should redirect_to(root_path())
    end
    context "when user is found" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state:"activating")
      end
      it "should render the activate template" do
        get :register, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should render_template('users/register')
      end
      it "should assign user and aasm_state should be 'register' if it was activating" do
        get :register, {:id=>@user.id, :token=>@user.token}, valid_session
        user = assigns[:user]
        user.id.should == @user.id
        user.registering?.should be_true
      end
      xit "should redirect to rating when user state is done" do

      end
    end
  end
end
