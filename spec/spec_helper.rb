
# Must go before all.
require_relative "support/simplecov"

# Self.
require_relative "../lib/rspec_magic"
require_relative "../lib/rspec_magic/unstable"

RSpecMagic::Config.spec_path = __dir__

# Load support files. Sorted alphabetically for greater control.
Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |fn| require fn }
