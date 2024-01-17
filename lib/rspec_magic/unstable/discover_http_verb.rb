# frozen_string_literal: true

# AF: TODO: Fin.

module RSpecMagic; module Unstable
  # Tralala some description.
  module DiscoverHttpVerb
    module Exports
      # Discover HTTP verb ("request method") from a properly formatted description string.
      # Raise an exception if no properly formatted descriptions were found.
      #
      #   describe "GET index" do
      #     it { expect(discover_http_verb).to eq :get }
      #   end
      #
      #   describe "POST submit" do
      #     it { expect(discover_http_verb).to eq :post }
      #   end
      #
      # @return [Symbol]
      def discover_http_verb
        while (klass ||= self.class) < RSpec::Core::ExampleGroup
          klass.description.to_s =~ /^(DELETE|GET|POST|PUT)\s/ and return $1.downcase.to_sym
          klass = klass.superclass
        end

        # No luck.
        raise "No properly formatted descriptions found"
      end
    end # Exports

    # Activate.
    defined?(RSpec) && RSpec.respond_to?(:configure) and RSpec.configure do |config|
      config.include Exports
    end
  end # module
end; end
