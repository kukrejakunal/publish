class Devise::CustomMailer < ::ActionMailer::Base
  include Devise::Mailers::Helpers
  include ApplicationHelper

  def new_user_notifications(record)
    @user = User.find(record["id"])
    mail(:to => @user.email, :subject => "You have been granted access to Article Application", :from => MAILER_EMAIL, :host => DOMAIN_NAME)
  end
end