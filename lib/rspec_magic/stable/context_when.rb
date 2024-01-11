# frozen_string_literal: true

"LODoc"

module RSpecMagic; module Stable
  # Create a self-descriptive <tt>"when …"</tt> context with one or more +let+ variables defined.
  # The blocks below are synonymous.
  #
  #   context_when name: "Joe", age: 25 do
  #     it do
  #       expect([name, age]).to eq ["Joe", 25]
  #     end
  #   end
  #
  #   context "when { name: \"Joe\", age: 25 }" do
  #     let(:name) { "Joe" }
  #     let(:age) { 25 }
  #     it do
  #       expect([name, age]).to eq ["Joe", 25]
  #     end
  #   end
  #
  # = Features
  #
  # Prepend +x+ to +context_when+ to exclude it:
  #
  #   xcontext_when … do
  #     …
  #   end
  #
  # ---
  #
  # Define a custom report line formatter:
  #
  #   describe "…" do
  #     def self._context_when_formatter(h)
  #       "when #{h.to_json}"
  #     end
  #
  #     context_when … do
  #       …
  #     end
  #   end
  #
  module ContextWhen
    module Exports
      # Default formatter for {#context_when}. Defined your custom one at the +describe+ level if needed.
      # @param [Hash] h
      # @return [String]
      def _context_when_formatter(h)
        # Extract labels for Proc arguments, if any.
        labels = {}
        h.each do |k, v|
          if v.is_a? Proc
            begin
              labels[k] = h.fetch(lk = "#{k}_label".to_sym)
              h.delete(lk)
            rescue KeyError
              raise ArgumentError, "`#{k}` is a `Proc`, `#{k}_label` must be given"
            end
          end
        end

        pcs = h.map do |k, v|
          [
            k.is_a?(Symbol) ? "#{k}:" : "#{k.inspect} =>",
            v.is_a?(Proc) ? labels[k] : v.inspect,
          ].join(" ")
        end

        "when { " + pcs.join(", ") + " }"
      end

      # Create a context.
      # @param [Hash] h
      def context_when(h, &block)
        context _context_when_formatter(h) do
          h.each do |k, v|
            if v.is_a? Proc
              let(k, &v)
            else
              # Generic scalar value.
              let(k) { v }
            end
          end
          class_eval(&block)
        end
      end

      # Create a temporarily excluded context.
      def xcontext_when(h, &block)
        xcontext _context_when_formatter(h) { class_eval(&block) }
      end
    end # Exports
  end # module

  # Activate.
  defined?(RSpec) && RSpec.respond_to?(:configure) and RSpec.configure do |config|
    config.extend ContextWhen::Exports
  end
end; end
