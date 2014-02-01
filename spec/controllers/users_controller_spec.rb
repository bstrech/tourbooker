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

  describe "GET edit" do
    xit "assigns the requested user as @user" do
      get :edit, {:id => user.to_param}, valid_session
      assigns(:user).should eq(user)
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
        post :create, {:user => {:email=>FactoryGirl.generate(:email)}}, valid_session
        response.should redirect_to(create_success_user_path(User.last))
      end
    end

    describe "with invalid params" do
      xit "assigns a newly created but unsaved user as @user" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => { "email" => "invalid value" }}, valid_session
        assigns(:user).should be_a_new(User)
      end

      xit "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        User.any_instance.stub(:save).and_return(false)
        post :create, {:user => { "email" => "invalid value" }}, valid_session
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


end
