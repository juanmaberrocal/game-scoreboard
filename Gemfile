source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0.rc1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.12'

# The official AWS SDK for Ruby. http://aws.amazon.com/sdkforruby
gem 'aws-sdk-s3', require: false

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# The authorization Gem for Ruby on Rails.
gem 'cancancan'

# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# JWT token authentication with devise and rails
gem 'devise', '>= 4.7.1'
gem 'devise-jwt', '~> 0.5.9'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# A lightning fast JSON:API serializer for Ruby Objects.
gem 'fast_jsonapi'

# Use Active Storage variant
gem 'image_processing', '~> 1.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors', '>= 1.0.4'

# Exception tracking and logging from Ruby to Rollbar https://docs.rollbar.com/docs/ruby
gem 'rollbar'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Simple, efficient background processing for Ruby http://sidekiq.org
gem 'sidekiq'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # A Ruby gem to load environment variables from `.env`.
  gem 'dotenv-rails'

  # factory_bot is a fixtures replacement with a straightforward definition syntax
  gem 'factory_bot_rails'

  # A library for generating fake data such as names, addresses, and phone numbers.
  gem 'faker'

  # A runtime developer console and IRB alternative with powerful introspection capabilities.
  gem 'pry', '~> 0.12.2'

  # rspec-rails brings the RSpec testing framework to Ruby on Rails as a drop-in alternative to its default testing framework
  gem 'rspec-rails', '~> 3.8'
end

group :test do
  # Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing. http://databasecleaner.github.io
  gem 'database_cleaner'

  # Simple one-liner tests for common Rails functionality https://matchers.shoulda.io
  gem 'shoulda-matchers'

  # RSpec results that your CI can read https://rubygems.org/gems/rspec_junit_formatter
  gem 'rspec_junit_formatter'

  # Library for stubbing and setting expectations on HTTP requests in Ruby.
  gem 'webmock'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  
  # Annotate Rails classes with schema and routes info
  gem 'annotate'

  # A Ruby static code analyzer and formatter, based on the community Ruby style guide. https://docs.rubocop.org
  gem 'rubocop', '~> 0.75.1', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
