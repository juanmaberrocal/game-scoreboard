# Now you need to tell the gem a couple of things:
#   Which test framework you're using
#   Which portion of the matchers you want to use
# You can supply this information by providing a configuration block.
#   Where this goes and what this contains depends on your project.
# Rails apps
# Assuming you are testing a Rails app, simply place this at the bottom of spec/rails_helper.rb
#   (or in a support file if you so choose):
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
