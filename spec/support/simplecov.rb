
#
# See https://github.com/simplecov-ruby/simplecov#getting-started.
#

require "simplecov"

SimpleCov.start do
  add_filter "libx/"
  add_filter "spec/"
end
