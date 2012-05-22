require 'rubygems'
require 'spork'
require 'cover_me'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

# Add I18n helper method anywhere
def t(*args)
  I18n.t(*args)
end

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/autorun'
  require 'rspec/rails'
  require 'capybara/rspec'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  # Capybara
  Capybara.default_host = "http://127.0.0.1"
  Capybara.javascript_driver = :webkit

  #class Capybara::Selenium::Node
  #  def set(value)
  #    if tag_name == 'input' and type == 'radio'
  #      click
  #    elsif tag_name == 'input' and type == 'checkbox'
  #      click
  #    elsif tag_name == 'input' and type == 'file'
  #      resynchronize do
  #        native.send_keys(value.to_s)
  #      end
  #    elsif tag_name == 'textarea' or tag_name == 'input'
  #      resynchronize do
  #        native.clear
  #        native.send_keys(value.to_s)
  #      end
  #    end
  #  end
  #end

  RSpec.configure do |config|
    # ## Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    # config.mock_with :rr


    # Factory girl
    config.include FactoryGirl::Syntax::Methods

    config.mock_with :rspec

    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.start
      DatabaseCleaner.clean
    end

    config.before(:each) do
      #DatabaseCleaner.start
    end

    config.after(:each) do
      # Clean the database
      #DatabaseCleaner.clean
      # Clear deliveries so that indexes match for isolated examples
      #ActionMailer::Base.deliveries.clear
    end

    # Clean db in before hook, better if stopped examples at the middle of execution
    config.before(:each, :clean_db => true) do |example|
      DatabaseCleaner.start
      DatabaseCleaner.clean
    end

    config.before(:each, :clean_mail => true) do |example|
      # Clear deliveries so that indexes match for isolated examples
      ActionMailer::Base.deliveries.clear
    end

    config.after(:suite) do
      # Clean the database
      DatabaseCleaner.clean
      # Clear deliveries so that indexes match for isolated examples
      ActionMailer::Base.deliveries.clear
    end

    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true

    # If true, the base class of anonymous controllers will be inferred
    # automatically. This will be the default behavior in future versions of
    # rspec-rails.
    config.infer_base_class_for_anonymous_controllers = false
  end

end

Spork.each_run do
  # Please reload routes
  load "#{Rails.root}/config/routes.rb"
end

# --- Instructions ---
# Sort the contents of this file into a Spork.prefork and a Spork.each_run
# block.
#
# The Spork.prefork block is run only once when the spork server is started.
# You typically want to place most of your (slow) initializer code in here, in
# particular, require'ing any 3rd-party gems that you don't normally modify
# during development.
#
# The Spork.each_run block is run each time you run your specs.  In case you
# need to load files that tend to change during development, require them here.
# With Rails, your application modules are loaded automatically, so sometimes
# this block can remain empty.
#
# Note: You can modify files loaded *from* the Spork.each_run block without
# restarting the spork server.  However, this file itself will not be reloaded,
# so if you change any of the code inside the each_run block, you still need to
# restart the server.  In general, if you have non-trivial code in this file,
# it's advisable to move it into a separate file so you can easily edit it
# without restarting spork.  (For example, with RSpec, you could move
# non-trivial code into a file spec/support/my_helper.rb, making sure that the
# spec/support/* files are require'd from inside the each_run block.)
#
# Any code that is left outside the two blocks will be run during preforking
# *and* during each_run -- that's probably not what you want.
#
# These instructions should self-destruct in 10 seconds.  If they don't, feel
# free to delete them.
