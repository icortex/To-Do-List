# Load the rails application
require File.expand_path('../application', __FILE__)

puts ENV["RAILS_ENV"]
# Initialize the rails application
Quipper::Application.initialize!
