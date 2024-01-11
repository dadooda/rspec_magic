# frozen_string_literal: true

"LODoc"

module RSpecMagic; module Stable
  # Create an automatic +let+ variable containing the method or action name,
  # computed from the description of the parent +describe+.
  #
  #   describe do
  #     use_method_discovery :m
  #
  #     subject { m }
  #
  #     describe "#first_name" do
  #       it { is_expected.to eq :first_name }
  #     end
  #
  #     describe ".some_stuff" do
  #       it { is_expected.to eq :some_stuff }
  #     end
  #
  #     describe "GET some_action" do
  #       describe "intermediate context" do
  #         it { is_expected.to eq :some_action }
  #       end
  #     end
  #   end
  #
  module UseMethodDiscovery
    module Exports
      # Enable the discovery mechanics.
      # @param [Symbol] method_let
      def use_method_discovery(method_let)
        # This context and all sub-contexts will respond to A and return B. "Signature" is based on
        # invocation arguments which can vary as we use the feature more intensively. Signature method
        # is the same, thus it shadows higher level definitions completely.
        signature = { method_let: method_let }
        define_singleton_method(:_umd_signature) { signature }

        let(method_let) do
          # NOTE: `self.class` responds to signature method, no need to probe and rescue.
          if (sig = (klass = self.class)._umd_signature) != signature
            raise "`#{method_let}` is shadowed by `#{sig.fetch(:method_let)}` in this context"
          end

          # NOTE: Better not `return` from the loop to keep it debuggable in case logic changes.
          found = nil
          while (klass._umd_signature rescue nil) == signature
            found = self.class.send(:_use_method_discovery_parser, klass.description.to_s) and break
            klass = klass.superclass
          end

          found or raise "No method-like descriptions found to use as `#{method_let}`"
        end
      end

      private

      # The parser used by {.use_method_discovery}.
      # @param [String] input
      # @return [Symbol] Method name, if parsed okay.
      # @return [nil] If input isn't method-like.
      def _use_method_discovery_parser(input)
        if (mat = input.match(/^(?:(?:#|\.|::)(\w+(?:\?|!|=|)|\[\])|(?:DELETE|GET|PUT|POST) (\w+))$/))
          (mat[1] || mat[2]).to_sym
        end
      end
    end # Exports
  end # module

  # Activate.
  defined?(RSpec) && RSpec.respond_to?(:configure) and RSpec.configure do |config|
    config.extend UseMethodDiscovery::Exports
  end
end; end
