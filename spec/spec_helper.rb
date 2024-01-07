
# Must go before all.
require_relative "support/simplecov"

# Load support files.
Dir[File.expand_path("support/**/*.rb", __dir__)].each { |fn| require fn }

# Load shared context hierarchy.
Dir[File.expand_path("**/_context.rb", __dir__)].each { |fn| require fn }
