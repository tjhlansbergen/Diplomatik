# application.rb - Tako Lansbergen 2020/01/28
# 
# Globale applicatie configuratie

require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module Diplomatik
  class Application < Rails::Application
    # Rails versie
    config.load_defaults 6.1

    # Applicatie configuratie
    config.max_log_entries = 100
    config.jwt_seed = "PeWKuQwMSEDLHnZt"
    config.oauth_url = "https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=78lq9215tgmbg2&redirect_uri=http%3A%2F%2F127.0.0.1%3A3000%2Fauth%2Flinkedin%2Fcallback&state=diplomatik&scope=r_emailaddress"
    config.oauth_redirect_url = "http://127.0.0.1:3000/auth/linkedin/callback"
    config.oauth_client_id = "78lq9215tgmbg2"
    config.oauth_client_secret = "msAbdNMbDbVCYmgo"
  end
end
