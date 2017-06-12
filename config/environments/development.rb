Rails.application.configure do
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => 'public, max-age=172800'
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Mailer configuration
  #config.action_mailer.perform_caching = false

  # config.action_mailer.smtp_settings = {
  #   address: 'smtp.gmail.com',
  #   port: 587,
  #   domain: 'gmail.com',
  #   authentication: 'plain',
  #   enable_starttls_auto: true,
  #   user_name: ENV['GMAIL_USER'],
  #   password: ENV['GMAIL_PASSWORD']
  # }
  config.action_mailer.default_url_options = { host: 'localhost:3000' }
  # config.action_mailer.delivery_method = :smtp
  # config.action_mailer.raise_delivery_errors = true
  # config.action_mailer.perform_deliveries = true

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Paperclip
  Paperclip.options[:command_path] = '/usr/local/bin/'

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end
