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
      redirect_to create_success_user_path(@user), notice: I18n.t("views.success.found_success_html", :link=>resend_authorization_user_path(@user))
    elsif @user.save
      #TODO send email here
      redirect_to create_success_user_path(@user), notice: I18n.t("views.success.create_success")
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
  def create_success

  end

  # GET /users/1/resend_authorization
  def resend_authorization
    #TODO send email here
    redirect_to create_success_user_path(@user), notice: I18n.t("views.success.create_success")
  end

  private
  def require_user
    @user = User.find_by_id(params[:id])
    unless @user
      redirect_to(root_path()) and return false
    end
  end
end
