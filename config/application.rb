require_relative 'boot'

# Check out what rails/all.rb is currently expanded to:
#  https://github.com/rails/rails/blob/master/railties/lib/rails/all.rb
# Replace `require 'rails/all'` with just the libs that you want and 
# exclude the rest
require 'active_record/railtie'
# require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'action_cable/engine'
# require 'action_mailbox/engine'
# require 'action_text/engine'
# require 'rails/test_unit/railtie'
require 'sprockets/railtie'

require 'dotenv'
Dotenv.load

require_relative 'constants'

require_relative 'errors'
ErrorManager.load!

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Stray
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.action_dispatch.rescue_responses.update( ErrorManager.custom_errors )
  end
end
