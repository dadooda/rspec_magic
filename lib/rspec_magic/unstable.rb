# frozen_string_literal: true

module RSpecMagic
  # "Unstable" feature set.
  #
  #   # `spec/spec_helper.rb`.
  #   require "rspec_magic/unstable"
  #
  module Unstable
  end
end

Dir[File.expand_path("../unstable/**/*.rb", __FILE__)].each { |fn| require fn }
