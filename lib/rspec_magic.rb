# frozen_string_literal: true

# Load the "world" features.
require_relative "rspec_magic/config"
require_relative "rspec_magic/version"

# Load supplementary classes.
require_relative "rspec_magic/egg_hash"
require_relative "rspec_magic/object_looks_like"

# Actual features are NOT loaded automatically.

# A set of extensions for writing compact and expressive tests.
module RSpecMagic
end
