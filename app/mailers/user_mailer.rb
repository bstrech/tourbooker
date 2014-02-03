class UserMailer < ActionMailer::Base
  default from: "donotreply@example.com"
  def create_user(user)
    @user = user
    @url  = activate_user_url(user, :token=>user.token)
    mail(to: @user.email, subject: I18n.t("action_mailer.activate_user.subject"))
  end

  def tour_scheduled_confirmation(user)
    @user = user
    mail(to: @user.email, subject: I18n.t("action_mailer.tour_scheduled_confirmation.subject"))
  end

  def new_tour_scheduled(user)
    @user = user
    mail(to: "tours@example.com", subject: I18n.t("action_mailer.new_tour_scheduled.subject"))
  end
end
