# frozen_string_literal: true

# AF: TODO: Fin.

module RSpecMagic; module Unstable
  # Tralala some description.
  module StubOf
    module Exports
      # A shorthand form of writing a conditional stub statement which hooks up
      # +of_obj_attr+ if one is available. The lines below are interchangeable.
      #
      #   stub_of :person, :name
      #   allow(person).to receive(:name).and_return(of_person_name) if defined?(of_person_name)
      #
      # = Features
      #
      # Trailing non-word characters, such as, <tt>"!"</tt> and <tt>"?"</tt> are stripped.
      #
      # ---
      #
      # It's possible to specify a custom let variable name.
      #
      #   # Will look for `of_user_admin`.
      #   stub_of :user, :admin?
      #
      #   # Will look for `is_admin`.
      #   stub_of :user, :admin?, :is_admin
      #
      # @param [Symbol | String] obj_name E.g. +:event+.
      # @param [Symbol | String] attr_name E.g. +:name+.
      # @param [Symbol | String] let_name <i>(defaults to: <tt>"of_#{obj_name}_#{attr_name}"</tt>)</i>
      def stub_of(obj_name, attr_name, let_name = nil)
        # Fetch object explicitly. Let it fail if typo or something.
        obj = public_send(obj_name)
        let_name ||= ["of", obj_name, "#{attr_name}".sub(/\W+$/, "")].join("_")
        begin
          allow(obj).to receive(attr_name).and_return(public_send(let_name))
        rescue NoMethodError
          # Let variable not found. Do nothing.
        end
      end
    end # Exports

    # Activate.
    defined?(RSpec) && RSpec.respond_to?(:configure) and RSpec.configure do |config|
      config.include Exports
    end
  end # module
end; end
