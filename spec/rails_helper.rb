ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rails_helper'
require 'rspec/rails'
require 'factory_bot_rails'

Dir[Rails.root.join("spec/support/*.rb")].each {|f| require f }
