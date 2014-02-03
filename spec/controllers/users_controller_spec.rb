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
    context "when user is found and is new" do
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
    end
    context "when user is found and in state of done" do
      before do
        @user = FactoryGirl.create(:user, is_done: true)
      end
      it "should redirect to rate" do
        get :activate, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(rate_user_path(@user, :token=>@user.token))
      end
    end
  end
  describe "PUT save_activation" do
    before do
      @valid_user_params = {:first_name=>"Joe", :last_name=>"User", :phone=>"1-800-867-5309"}
    end
    it "should redirect to root if user id is not found" do
      put :save_activation, {:id=>0, :user=>@valid_user_params}, valid_session
      response.should redirect_to(root_path())
    end
    it "should redirect to root if user is found but token doesn't match" do
      @user = FactoryGirl.create(:user, is_done: false)
      put :save_activation, {:id=>@user.id, :token=>"#{@user.token}r", :user=>@valid_user_params}, valid_session
      response.should redirect_to(root_path())
    end
    context "when user is found and is in state of new" do
      before do
        @user = FactoryGirl.create(:user, is_done: false)
      end
      describe "with valid params" do
        it "should assign user with state of activating" do
          put :save_activation, {:id=>@user.id, :token=>@user.token, :user=>@valid_user_params}, valid_session
          user = assigns[:user]
          user.id.should == @user.id
          user.activating?.should be_true
        end
        it "updates the requested user" do
          put :save_activation, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          @valid_user_params.each do |k,v|
            @user[k].should == v
          end
        end
        it "strips other attributes which are not expected" do
          @user_attributes = @valid_user_params.merge!(token: "new_token", email: 'new@example.com', ip_address: "new_ip", preferred_tour_date: "2014-02-30", amn_pool: true, amn_rec_room:true, amn_movie_theater: true, amn_doctor: true, amn_time_machine: true, rating: 5)
          put :save_activation, {:id=>@user.id, :user=>@user_attributes, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          @user_attributes.each do |k,v|
            if ([:first_name, :last_name, :phone].include?(k))
              @user[k].should == v
            else
              @user[k].should_not == v
            end
          end
        end
        it "assigns the requested user as @user" do
          put :save_activation, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          assigns(:user).should eq(@user)
        end

        it "redirects to the register_user_path" do
          put :save_activation, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          response.should redirect_to(register_user_path(@user, :token=>@user.token))
        end
      end
      describe "with invalid params" do
        before do
          @invalid_user_params = {:first_name=>"", :last_name=>"", :phone=>""}
        end
        it "assigns user as @user in the state of activating" do
          put :save_activation, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          assigns(:user).should eq(@user)
          user = assigns[:user]
          user.activating?.should be_true
        end
        it "re-renders the activate template'" do
          User.any_instance.stub(:save).and_return(false)
          put :save_activation, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          response.should render_template("users/activate")
        end
      end
    end
    context "when user is found and is in state of activating" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "activating")
      end
      describe "with valid params" do
        it "should assign user with state of activating" do
          put :save_activation, {:id=>@user.id, :token=>@user.token, :user=>@valid_user_params}, valid_session
          user = assigns[:user]
          user.id.should == @user.id
          user.activating?.should be_true
        end
        it "updates the requested user" do
          put :save_activation, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          @valid_user_params.each do |k,v|
            @user[k].should == v
          end
        end
        it "strips other attributes which are not expected" do
          @user_attributes = @valid_user_params.merge!(token: "new_token", email: 'new@example.com', ip_address: "new_ip", preferred_tour_date: "2014-02-30", amn_pool: true, amn_rec_room:true, amn_movie_theater: true, amn_doctor: true, amn_time_machine: true, rating: 5)
          put :save_activation, {:id=>@user.id, :user=>@user_attributes, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          @user_attributes.each do |k,v|
            if ([:first_name, :last_name, :phone].include?(k))
              @user[k].should == v
            else
              @user[k].should_not == v
            end
          end
        end
        it "assigns the requested user as @user" do
          put :save_activation, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          assigns(:user).should eq(@user)
        end

        it "redirects to the register_user_path" do
          put :save_activation, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          response.should redirect_to(register_user_path(@user, :token=>@user.token))
        end
      end
      describe "with invalid params" do
        before do
          @invalid_user_params = {:first_name=>"", :last_name=>"", :phone=>""}
        end
        it "assigns user as @user in the state of activating" do
          put :save_activation, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          assigns(:user).should eq(@user)
          user = assigns[:user]
          user.activating?.should be_true
        end
        it "re-renders the activate template'" do
          User.any_instance.stub(:save).and_return(false)
          put :save_activation, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          response.should render_template("users/activate")
        end
      end
    end
    context "when user is found and is in state of registering" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "registering")
      end
      describe "with valid params" do
        it "should assign user with state of activating" do
          put :save_activation, {:id=>@user.id, :token=>@user.token, :user=>@valid_user_params}, valid_session
          user = assigns[:user]
          user.id.should == @user.id
          user.activating?.should be_true
        end
        it "updates the requested user" do
          put :save_activation, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          @valid_user_params.each do |k,v|
            @user[k].should == v
          end
        end
        it "strips other attributes which are not expected" do
          @user_attributes = @valid_user_params.merge!(token: "new_token", email: 'new@example.com', ip_address: "new_ip", preferred_tour_date: "2014-02-30", amn_pool: true, amn_rec_room:true, amn_movie_theater: true, amn_doctor: true, amn_time_machine: true, rating: 5)
          put :save_activation, {:id=>@user.id, :user=>@user_attributes, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          @user_attributes.each do |k,v|
            if ([:first_name, :last_name, :phone].include?(k))
              @user[k].should == v
            else
              @user[k].should_not == v
            end
          end
        end
        it "assigns the requested user as @user" do
          put :save_activation, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          assigns(:user).should eq(@user)
        end

        it "redirects to the register_user_path" do
          put :save_activation, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          response.should redirect_to(register_user_path(@user, :token=>@user.token))
        end
      end
      describe "with invalid params" do
        before do
          @invalid_user_params = {:first_name=>"", :last_name=>"", :phone=>""}
        end
        it "assigns user as @user in the state of activating" do
          put :save_activation, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          assigns(:user).should eq(@user)
          user = assigns[:user]
          user.activating?.should be_true
        end
        it "re-renders the activate template'" do
          User.any_instance.stub(:save).and_return(false)
          put :save_activation, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          response.should render_template("users/activate")
        end
      end
    end
    context "when user is found and in state of done" do
      before do
        @user = FactoryGirl.create(:user, is_done: true)
      end
      it "should redirect to rate" do
        User.any_instance.should_not_receive(:save)
        put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@valid_user_params}, valid_session
        response.should redirect_to(rate_user_path(@user, :token=>@user.token))
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
    end
    context "when user is found and in state of done" do
      before do
        @user = FactoryGirl.create(:user, is_done: true)
      end
      it "should redirect to rate" do
        get :register, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(rate_user_path(@user, :token=>@user.token))
      end
    end
  end
  describe "PUT save_registration" do
    before do
      @valid_user_params = {:preferred_tour_date=>"2014-02-01", :amn_pool=>false, :amn_rec_room=>false, :amn_rec_room=>true, :amn_doctor=>true, :amn_time_machine=>true}
    end
    it "should redirect to root if user id is not found" do
      put :save_registration, {:id=>0, :user=>@valid_user_params}, valid_session
      response.should redirect_to(root_path())
    end
    it "should redirect to root if user is found but token doesn't match" do
      @user = FactoryGirl.create(:user, is_done: false)
      put :save_registration, {:id=>@user.id, :token=>"#{@user.token}r", :user=>@valid_user_params}, valid_session
      response.should redirect_to(root_path())
    end
    context "when user is found and is in state of new" do
      before do
        @user = FactoryGirl.create(:user, is_done: false)
      end
      describe "with valid params" do
        it "should redirect to activate" do
          put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@valid_user_params}, valid_session
          response.should redirect_to(activate_user_path(@user, :token=>@user.token))
        end
      end
      describe "with invalid params" do
        before do
          @invalid_user_params = {:preferred_tour_date=>""}
        end
        it "should redirect to activate" do
          put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@valid_user_params}, valid_session
          response.should redirect_to(activate_user_path(@user, :token=>@user.token))
        end
      end
    end
    context "when user is found and is in state of activating" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "activating")
      end
      describe "with valid params" do
        it "should assign user with state of done" do
          put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@valid_user_params}, valid_session
          user = assigns[:user]
          user.id.should == @user.id
          user.done?.should be_true
        end

        it "should set ip_address" do
          put :save_registration, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          user = assigns[:user]
          user.ip_address.should_not be_nil
        end

        it "updates the requested user" do
          put :save_registration, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          @valid_user_params.each do |k,v|
            if k == :preferred_tour_date
              @user[k].should == Date.parse(v)
            else
              @user[k].should == v
            end
          end
        end
        it "strips other attributes which are not expected" do
          user_attributes = @valid_user_params.merge!(token: "new_token", email: 'new@example.com', ip_address: "new_ip", first_name: "newname", last_name: "new_name", phone: "newphone", rating: 5)
          put :save_registration, {:id=>@user.id, :user=>user_attributes, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          user_attributes.each do |k,v|
            if ([:preferred_tour_date, :amn_pool, :amn_doctor, :amn_movie_theater, :amn_pool, :amn_rec_room, :amn_time_machine].include?(k))
              if k == :preferred_tour_date
                @user[k].should == Date.parse(v)
              else
                @user[k].should == v
              end
            else
              @user[k].should_not == v
            end
          end
        end
        it "assigns the requested user as @user" do
          put :save_registration, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          assigns(:user).should eq(@user)
        end
        it "redirects to the registration_success_user_path" do
          put :save_registration, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          response.should redirect_to(registration_success_user_path(@user, :token=>@user.token))
        end
      end
      describe "with invalid params" do
        before do
          @invalid_user_params = {:preferred_tour_date=>""}
        end
        it "assigns user as @user in the state of registering" do
          put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          assigns(:user).should eq(@user)
          user = assigns[:user]
          user.registering?.should be_true
        end
        it "re-renders the register template'" do
          User.any_instance.stub(:save).and_return(false)
          put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          response.should render_template("users/register")
        end
      end
    end
    context "when user is found and is in state of registering" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "registering")
      end
      describe "with valid params" do
        it "should assign user with state of done" do
          put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@valid_user_params}, valid_session
          user = assigns[:user]
          user.id.should == @user.id
          user.done?.should be_true
        end
        it "updates the requested user" do
          put :save_registration, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          @valid_user_params.each do |k,v|
            if k == :preferred_tour_date
              @user[k].should == Date.parse(v)
            else
              @user[k].should == v
            end
          end
        end
        it "strips other attributes which are not expected" do
          user_attributes = @valid_user_params.merge!(token: "new_token", email: 'new@example.com', ip_address: "new_ip", first_name: "newname", last_name: "new_name", phone: "newphone", rating: 5)
          put :save_registration, {:id=>@user.id, :user=>user_attributes, :token=>@user.token}, valid_session
          user = assigns[:user]
          @user.reload
          @user.should == user
          user_attributes.each do |k,v|
            if ([:preferred_tour_date, :amn_pool, :amn_doctor, :amn_movie_theater, :amn_pool, :amn_rec_room, :amn_time_machine].include?(k))
              if k == :preferred_tour_date
                @user[k].should == Date.parse(v)
              else
                @user[k].should == v
              end
            else
              @user[k].should_not == v
            end
          end
        end
        it "assigns the requested user as @user" do
          put :save_registration, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          assigns(:user).should eq(@user)
        end

        it "redirects to the registration_success_user_path" do
          put :save_registration, {:id=>@user.id, :user=>@valid_user_params, :token=>@user.token}, valid_session
          response.should redirect_to(registration_success_user_path(@user, :token=>@user.token))
        end
      end
      describe "with invalid params" do
        before do
          @invalid_user_params = {:preferred_tour_date=>""}
        end
        it "assigns user as @user in registering state" do
          put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          assigns(:user).should eq(@user)
          user = assigns[:user]
          user.registering?.should be_true
        end
        it "re-renders the register template'" do
          User.any_instance.stub(:save).and_return(false)
          put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@invalid_user_params}, valid_session
          response.should render_template("users/register")
        end
      end
    end
    context "when user is found and in state of done" do
      before do
        @user = FactoryGirl.create(:user, is_done: true)
      end
      it "should redirect to rate" do
        User.any_instance.should_not_receive(:save)
        put :save_registration, {:id=>@user.id, :token=>@user.token, :user=>@valid_user_params}, valid_session
        response.should redirect_to(rate_user_path(@user, :token=>@user.token))
      end
    end
  end
  describe "GET registration_success" do
    it "should redirect to root if user id is not found" do
      get :registration_success, {:id=>0}, valid_session
      response.should redirect_to(root_path())
    end
    it "should redirect to root if user is found but token doesn't match" do
      @user = FactoryGirl.create(:user, is_done: false)
      get :registration_success, {:id=>@user.id, :token=>"#{@user.token}r"}, valid_session
      response.should redirect_to(root_path())
    end
    context "when user is found and is in state of activating" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "activating")
      end
      it "should redirect to activate" do
        get :registration_success, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(activate_user_path(@user, :token=>@user.token))
      end
    end
    context "when user is found and is in state of registering" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "registering")
      end
      it "should redirect to activate" do
        get :registration_success, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(activate_user_path(@user, :token=>@user.token))
      end
    end
    context "when user is found and in state of done" do
      before do
        @user = FactoryGirl.create(:user, is_done: true)
      end
      it "should render the registration_success template" do
        get :registration_success, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should render_template('users/registration_success')
      end
    end
  end
  describe "GET rate" do
    it "should redirect to root if user id is not found" do
      get :rate, {:id=>0}, valid_session
      response.should redirect_to(root_path())
    end
    it "should redirect to root if user is found but token doesn't match" do
      @user = FactoryGirl.create(:user, is_done: false)
      get :rate, {:id=>@user.id, :token=>"#{@user.token}r"}, valid_session
      response.should redirect_to(root_path())
    end
    context "when user is found and is in state of new" do
      before do
        @user = FactoryGirl.create(:user, is_done: false)
      end
      it "should redirect to activate" do
        get :rate, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(activate_user_path(@user, :token=>@user.token))
      end
    end
    context "when user is found and is in state of activating" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "activating")
      end
      it "should redirect to activate" do
        get :rate, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(activate_user_path(@user, :token=>@user.token))
      end
    end
    context "when user is found and is in state of registering" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "registering")
      end
      it "should redirect to activate" do
        get :rate, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(activate_user_path(@user, :token=>@user.token))
      end
    end
    context "when user is found and is in state of done" do
      before do
        @user = FactoryGirl.create(:user, is_done: true)
      end
      it "should render the rate template" do
        get :rate, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should render_template('users/rate')
      end
    end
  end
  describe "PUT save_rating" do

  end
  describe "GET rating_success" do
    it "should redirect to root if user id is not found" do
      get :rating_success, {:id=>0}, valid_session
      response.should redirect_to(root_path())
    end
    it "should redirect to root if user is found but token doesn't match" do
      @user = FactoryGirl.create(:user, is_done: true)
      get :rating_success, {:id=>@user.id, :token=>"#{@user.token}r"}, valid_session
      response.should redirect_to(root_path())
    end
    context "when user is found and is in state of activating" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "activating")
      end
      it "should redirect to activate" do
        get :rating_success, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(activate_user_path(@user, :token=>@user.token))
      end
    end
    context "when user is found and is in state of registering" do
      before do
        @user = FactoryGirl.create(:user, is_done: false, is_rating: true, aasm_state: "registering")
      end
      it "should redirect to activate" do
        get :rating_success, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should redirect_to(activate_user_path(@user, :token=>@user.token))
      end
    end
    context "when user is found and in state of done" do
      before do
        @user = FactoryGirl.create(:user, is_done: true)
      end
      it "should render the create_success template" do
        get :rating_success, {:id=>@user.id, :token=>@user.token}, valid_session
        response.should render_template('users/rating_success')
      end
    end
  end
end
