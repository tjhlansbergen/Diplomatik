require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Diplomatik
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.max_log_entries = 100
    config.jwt_seed = "PeWKuQwMSEDLHnZt"
    config.oauth_url = "https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=78lq9215tgmbg2&redirect_uri=http%3A%2F%2F127.0.0.1%3A3000%2Fauth%2Flinkedin%2Fcallback&state=diplomatik&scope=r_emailaddress"
    config.oauth_redirect_url = "http://127.0.0.1:3000/auth/linkedin/callback"
    config.oauth_client_id = "78lq9215tgmbg2"
    config.oauth_client_secret = "msAbdNMbDbVCYmgo"
  end
end
