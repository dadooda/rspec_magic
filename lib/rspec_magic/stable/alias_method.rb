# frozen_string_literal: true

module RSpecMagic; module Stable
  # A matcher to check that a method is an alias of another method.
  #
  #   describe User do
  #     it { is_expected.to alias_method(:admin?, :is_admin) }
  #   end
  #
  module AliasMethod
  end

  # NOTE: `RSpec` has an autoloader of its own. Constants might not respond until we touch them.
  begin; RSpec::Matchers; rescue NameError; end

  # Activate.
  defined?(RSpec::Matchers) && RSpec::Matchers.respond_to?(:define) and RSpec::Matchers.define(:alias_method) do |new_name, old_name|
    match do |subject|
      expect(subject.method(new_name)).to eq subject.method(old_name)
    end

    description do
      "have #{new_name.inspect} aliased to #{old_name.inspect}"
    end
  end
end; end
