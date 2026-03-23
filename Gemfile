# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.1.2'
# Use mysql as the database for Active Record
gem 'mysql2', '~> 0.5'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Security pins for transitive dependencies (bundler-audit)
gem 'action_text-trix', '>= 2.1.17'
gem 'nokogiri', '>= 1.19.1'
gem 'rack', '>= 3.2.5'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Add HTTP asset caching/compression and X-Sendfile acceleration to Puma [https://github.com/basecamp/thruster/]
gem 'thruster', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

gem 'active_model_serializers' # for object serialization
gem 'dotenv-rails', groups: %i[development test] # Load environment variables from .env
gem 'faraday'
gem 'faraday-net_http'
gem 'interactor-initializer' # to be used for writing interactors

group :development, :test do
  gem 'brakeman'
  gem 'bundler-audit'
  gem 'factory_bot_rails' # for creating spec fixtures
  gem 'rspec'
  gem 'rspec-rails' # we skipped default testing framework for Rails and are using RSpec instead
  gem 'webmock'
end

group :development do
  gem 'rubocop', require: false
end
