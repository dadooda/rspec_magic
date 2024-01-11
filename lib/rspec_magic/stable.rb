# frozen_string_literal: true

module RSpecMagic
  # "Stable" feature set.
  #
  #   # `spec/spec_helper.rb`.
  #   require "rspec_magic/stable"
  #
  module Stable
  end
end

Dir[File.expand_path("../stable/**/*.rb", __FILE__)].each { |fn| require fn }
