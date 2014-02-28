begin
  mailer = YAML.load(File.open("#{Rails.root}/config/application.yml"))[Rails.env]["mailer"]
rescue
  mailer = {}
end

MAILER_EMAIL = mailer["notifications_email"] || "notifications@write_up.com"
DOMAIN_NAME = mailer["domain_name"] || "publishIT.com"