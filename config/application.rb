require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require 'mutations'

Bundler.require(*Rails.groups)
module Mlog
  class Application < Rails::Application
  end
end
