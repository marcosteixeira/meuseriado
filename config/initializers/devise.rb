# Use this hook to configure devise mailer, warden hooks and so forth.
# Many of these configuration options can be set straight in your model.
Devise.setup do |config|
  FACEBOOK_CONFIG = YAML.load_file("#{::Rails.root}/config/facebook.yml")[::Rails.env]
  GOOGLE_CONFIG = YAML.load_file("#{::Rails.root}/config/google.yml")[::Rails.env]
  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in Devise::Mailer,
  # note that it will be overwritten if you use your own mailer class with default "from" parameter.
  config.mailer_sender = "contato@meuseriado.com.br"

  # Configure the class responsible to send e-mails.
  # config.mailer = "Devise::Mailer"

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/active_record'

  # Configure which authentication keys should be case-insensitive.
  # These keys will be downcased upon creating or modifying a user and when used
  # to authenticate or find a user. Default is :email.
  config.case_insensitive_keys = [:email]

  # Configure which authentication keys should have whitespace stripped.
  # These keys will have whitespace before and after removed upon creating or
  # modifying a user and when used to authenticate or find a user. Default is :email.
  config.strip_whitespace_keys = [:email]

  # By default Devise will store the user in session. You can skip storage for
  # :http_auth and :token_auth by adding those symbols to the array below.
  # Notice that if you are skipping storage for all authentication paths, you
  # may want to disable generating routes to Devise's sessions controller by
  # passing :skip => :sessions to `devise_for` in your config/routes.rb

  config.skip_session_storage = [:http_auth]

  # Limiting the stretches to just one in testing will increase the performance of
  # your test suite dramatically. However, it is STRONGLY RECOMMENDED to not use
  # a value less than 10 in other environments.
  config.stretches = Rails.env.test? ? 1 : 10

  # ==> Configuration for :validatable
  # Range for password length. Default is 8..128.
  config.password_length = 8..128

  # Time interval you can reset your password with a reset password key.
  # Don't put a too small interval or your users won't have the time to
  # change their passwords.
  config.reset_password_within = 6.hours

  # The default HTTP method used to sign out a resource. Default is :delete.
  config.sign_out_via = :get

  require "omniauth-facebook"
  config.omniauth :facebook, FACEBOOK_CONFIG['app_id'], FACEBOOK_CONFIG['secret'], :scope => 'email, publish_actions, manage_notifications'
  require "omniauth-google-oauth2"
  config.omniauth :google_oauth2, GOOGLE_CONFIG['app_id'], GOOGLE_CONFIG['secret'], {access_type: "offline", approval_prompt: ""}
  config.secret_key = '273d815c4c384c4c1164a006bc25b40d805a2888dd973d11245c96316cb347d31500b9d4b381d1524e08db9f2e07c7532d7829eee8761fe24df02b4c3048c489'
end
