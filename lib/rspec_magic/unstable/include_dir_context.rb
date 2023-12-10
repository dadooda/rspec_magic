# frozen_string_literal: true

require_relative "../config"

module RSpecMagic; module Unstable
  # Include hierarchical contexts from <tt>spec/</tt> up to spec root.
  #
  # = Usage
  #
  #   describe Something do
  #     include_dir_context __dir__
  #     …
  #   end
  module IncludeDirContext
    module Exports
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

# OPTIMIZE: Find and revive my older tests for this.
