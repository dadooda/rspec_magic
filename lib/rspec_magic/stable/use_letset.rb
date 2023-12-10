# frozen_string_literal: true

module RSpecMagic; module Stable
  # Define methods to manage a set of custom +let+ variables which act as a distinct collection.
  #
  #   describe "…" do
  #     use_letset :let_a, :attrs
  #   end
  #
  # OPTIMIZE: Declarative mode plays super nicely with `context_when`.
  #
  # ----
  #
  # Better implementation of {.use_custom_let}, which is fully context-aware.
  # Name is ugly on purpose to make all invocations explicit.
  #
  #   use_cl2 :let_a, :attrs
  #
  # ----
  #
  # Define methods to manage of <tt>let</tt> variables which act as a distinct subset.
  #
  #   RSpec.describe SomeKlass do
  #     use_custom_let(:let_a, :attrs)      # (1)
  #     use_custom_let(:let_p, :params)     # (2)
  #     ...
  #
  # In above examples, (1) provides our suite with:
  #
  #   def self.let_a(let, &block)
  #   def attrs(include: [])
  #
  # , thus this now becomes possible:
  #
  #   describe "attrs" do
  #     let_a(:name) { "Joe" }
  #     let_a(:age) { 25 }
  #     let(:gender) { :male }
  #     it do
  #       expect(name).to eq "Joe"
  #       expect(age).to eq 25
  #       expect(attrs).to eq(name: "Joe", age: 25)
  #       expect(attrs(include: [:gender])).to eq(name: "Joe", age: 25, gender: :male)
  #     end
  #   end
  #
  # By not providing a block it's possible to <b>declare</b> a custom <tt>let</tt> variable
  # and be able to redefine it later via regular <tt>let</tt>. This will work:
  #
  #   describe "declarative (no block) usage" do
  #     let_a(:name)
  #
  #     subject { attrs }
  #
  #     context "when no other `let` value" do
  #       it { is_expected.to eq({}) }
  #     end
  #
  #     context "when `let`" do
  #       let(:name) { "Joe" }
  #       it { is_expected.to eq(name: "Joe") }
  #     end
  #   end
  #
  # NOTE: At the moment the feature only works if <tt>use_custom_let</tt> is invoked from a
  # top-level (<tt>RSpec.describe</tt>) context. Correct usage in sub-context is yet not possible.
  module UseLetset
    module Exports
      # Define the collection.
      # @param let_method [Symbol]
      # @param collection_let [Symbol]
      # @return [void]
      def use_letset(let_method, collection_let)
        keys_m = "_#{collection_let}_keys".to_sym

        # See "Implementation notes" on failed implementation of "collection only" mode.

        # E.g. "_data_keys" or something.
        define_singleton_method(keys_m) do
          if instance_variable_defined?(k = "@#{keys_m}")
            instance_variable_get(k)
          else
            # Start by copying superclass's known vars or default to `[]`.
            instance_variable_set(k, (superclass.send(keys_m).dup rescue []))
          end
        end

        define_singleton_method let_method, ->(k, &block) do
          (send(keys_m) << k).uniq!
          # Create a `let` variable unless it's a declaration call (`let_a(:name)`).
          let(k, &block) if block
        end

        define_method(collection_let) do
          {}.tap do |h|
            self.class.send(keys_m).each do |k|
              h[k] = public_send(k) if respond_to?(k)
            end
          end
        end
      end
    end # Exports
  end # module

  # Activate.
  defined?(RSpec) && RSpec.respond_to?(:configure) and RSpec.configure do |config|
    config.extend UseLetset::Exports
  end
end; end

#
# Implementation notes:
#
# * There was once an idea to support `use_letset` in "collection only" mode. Say, `let_a` appends
#   to `attrs`, but doesn't publish a let variable. This change IS COMPLETELY NOT IN LINE with
#   RSpec design. Let variables are methods and the collection is built by probing for those
#   methods. "Collection only" would require a complete redesign. It's easier to implement another
#   helper method for that, or, even better, do it with straight Ruby right in the test where
#   needed. The need for "collection only" mode is incredibly rare, say, specific serializer
#   tests.
