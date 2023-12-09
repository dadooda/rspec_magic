# frozen_string_literal: true

"LODoc"

module RSpecMagic
  # Stable features.
  module Stable
  end
end

Dir[File.expand_path("../stable/**/*.rb", __FILE__)].each { |fn| require fn }
