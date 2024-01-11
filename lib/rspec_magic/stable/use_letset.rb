# frozen_string_literal: true

"LODoc"

module RSpecMagic; module Stable
  # Define a method to create +let+ variables, which comprise a +Hash+ collection.
  #
  #   describe do
  #     # Method is `let_a`. Collection is `attrs`.
  #     use_letset :let_a, :attrs
  #
  #     # Declare `attrs` elements.
  #     let_a(:age)
  #     let_a(:name)
  #
  #     subject { attrs }
  #
  #     # None of the elements is set yet.
  #     it { is_expected.to eq({}) }
  #
  #     # Set `name` and see it in the collection.
  #     context_when name: "Joe" do
  #       it { is_expected.to eq(name: "Joe") }
  #
  #       # Add `age` and see both in the collection.
  #       context_when age: 25 do
  #         it { is_expected.to eq(name: "Joe", age: 25) }
  #       end
  #     end
  #   end
  #
  # When used with a block, +let_a+ behaves like a regular +let+:
  #
  #   describe do
  #     use_letset :let_a, :attrs
  #
  #     let_a(:age) { 25 }
  #     let_a(:name) { "Joe" }
  #
  #     it { expect(attrs).to eq(name: "Joe", age: 25) }
  #   end
  #
  module UseLetset
    module Exports
      # Define the collection.
      # @param let_method [Symbol]
      # @param collection_let [Symbol]
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
