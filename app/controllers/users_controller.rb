class UsersController < ApplicationController
  before_filter :require_user, :except=>[:new, :create]
  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  def create
    @user = User.find_or_initialize_by_email(params[:user][:email])

    if !@user.new_record?
      redirect_to create_success_user_path(@user, :token=>@user.token), notice: I18n.t("views.success.found_success_html", :link=>resend_activation_user_path(@user, :token=>@user.token))
    elsif @user.save
      #TODO send email here
      redirect_to create_success_user_path(@user, :token=>@user.token), notice: I18n.t("views.success.create_success")
    else
      render action: "new"
    end
  end

  # GET /users/1/create_success
  def create_success
    #nothing to do here
  end

  # GET /users/1/activate
  def activate
    @user.activate if @user.may_activate?
  end

  # PUT /users/1/save_activation
  def save_activation
    @user.activate if @user.may_activate?

  end

  # GET /users/1/register
  def register
    @user.register if @user.may_register?

  end

  # PUT /users/1/save_registration
  def save_registration
    @user.register if @user.may_register?
  end

  # GET /users/1/resend_activation
  def resend_activation
    @user.send_create_email
    redirect_to create_success_user_path(@user, :token=>@user.token), notice: I18n.t("views.success.create_success")
  end

  # GET /users/1/registration_success
  def registration_success
    #nothing to do here
  end

  # GET /users/1/rate
  def rate
    redirect_to(activate_user_path(@user, :token=>@user.token)) and return unless @user.done?
  end

  # GET /users/1/rating_success
  def rating_success
    #nothing to do here
  end

  private
  def require_user
    @user = User.find_by_id_and_token(params[:id], params[:token])
    unless @user
      redirect_to(root_path()) and return false
    end
  end
end
