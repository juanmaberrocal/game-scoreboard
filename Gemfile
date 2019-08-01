source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0.rc1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# A lightning fast JSON:API serializer for Ruby Objects.
gem 'fast_jsonapi'

# Simple, efficient background processing for Ruby http://sidekiq.org
gem 'sidekiq'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]

  # A Ruby gem to load environment variables from `.env`.
  gem 'dotenv-rails'

  # rspec-rails brings the RSpec testing framework to Ruby on Rails as a drop-in alternative to its default testing framework
  gem 'rspec-rails', '~> 3.8'

  # factory_bot is a fixtures replacement with a straightforward definition syntax
  gem 'factory_bot_rails'

  # A library for generating fake data such as names, addresses, and phone numbers.
  gem 'faker'
end

group :test do
  # Strategies for cleaning databases in Ruby. Can be used to ensure a clean state for testing. http://databasecleaner.github.io
  gem 'database_cleaner'

  # Simple one-liner tests for common Rails functionality https://matchers.shoulda.io
  gem 'shoulda-matchers'

  # RSpec results that your CI can read https://rubygems.org/gems/rspec_junit_formatter
  gem 'rspec_junit_formatter'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  
  # Annotate Rails classes with schema and routes info
  gem 'annotate'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
