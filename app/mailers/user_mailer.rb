class UserMailer < ActionMailer::Base
 default from: "noreply@auctioneer.com"
  
  def email_reset_password(user, reset_token)
    @user=user
    @url= reset_url(reset_token)
    to=user.email
    mail(:to => to, :subject => I18n.t(:reset_password))
  end
end

