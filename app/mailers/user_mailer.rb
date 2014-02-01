class UserMailer < ActionMailer::Base
  default from: "donotreply@example.com"
  def create_user(user)
    @user = user
    @url  = authorize_user_url(user, :token=>user.token)
    mail(to: @user.email, subject: I18n.t("actionmailer.authorize_user.subject"))
  end
end
