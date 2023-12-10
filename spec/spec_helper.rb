
# Must go before all.
require_relative "support/simplecov"

# Load support files. Sorted alphabetically for greater control.
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |fn| require fn }
