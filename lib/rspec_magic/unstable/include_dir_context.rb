# frozen_string_literal: true

require_relative "../config"

module RSpecMagic; module Unstable
  # Organize shared contexts in a hierarchy.
  # Import relevant shared contexts into the given test.
  #
  #   describe … do
  #     include_dir_context __dir__
  #     …
  #   end
  #
  # See the README file for more information.
  module IncludeDirContext
    module Exports
      # Include the relevant shared contexts hierarchy.
      # @param [String] dir
      def include_dir_context(dir)
        root = Config.spec_path

        d, steps = dir, []
        while d.start_with?(root)
          steps << d
          d = File.split(d).first
        end

        steps.reverse.each do |d|
          begin; include_context d; rescue ArgumentError; end
        end
      end
    end # Exports
  end # module

  # Activate.
  defined?(RSpec) && RSpec.respond_to?(:configure) and RSpec.configure do |config|
    config.extend IncludeDirContext::Exports
  end
end; end
