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

  # PUT /users/1
  def update
    if @user.update_attributes(params[:user])
      redirect_to @user, notice: 'User was successfully updated.'
    else
      render action: "edit"
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


  # GET /users/1/resend_activation
  def resend_activation
    @user.send_create_email
    redirect_to create_success_user_path(@user, :token=>@user.token), notice: I18n.t("views.success.create_success")
  end

  private
  def require_user
    @user = User.find_by_id_and_token(params[:id], params[:token])
    unless @user
      redirect_to(root_path()) and return false
    end
  end
end
