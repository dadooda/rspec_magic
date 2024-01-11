# frozen_string_literal: true

module RSpecMagic
  # The configuration.
  module Config
    class << self
      attr_writer :spec_path

      # The path of where the specs are.
      # Most commonly, <tt>spec/</tt> of the project's directory.
      # @return [String]
      def spec_path
        @spec_path || raise("`#{__method__}` must be configured")
      end
    end
  end
end
