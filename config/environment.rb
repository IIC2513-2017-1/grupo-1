# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

ActionMailer::Base.perform_caching = false

ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  port: 587,
  domain: 'gmail.com',
  authentication: 'plain',
  enable_starttls_auto: true,
  user_name: ENV['GMAIL_USER'],
  password: ENV['GMAIL_PASSWORD']
}

ActionMailer::Base.default_url_options = { host: 'localhost:3000' }
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.perform_deliveries = true
