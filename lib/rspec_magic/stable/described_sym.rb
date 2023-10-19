# frozen_string_literal: true

module RSpecMagic; module Stable
  # Transform <tt>described_class</tt> into an underscored symbol.
  #
  #   describe UserProfile do
  #     it { expect(described_sym).to eq :user_profile }
  #     it { expect(me).to eq :user_profile }
  #   end
  #
  # Usage with a factory:
  #
  #   describe UserProfile do
  #     let(:obj1) { create described_sym }
  #     let(:obj2) { create me }
  #     …
  #   end
  module DescribedSym
    # @return [Symbol]
    def described_sym
      # OPTIMIZE: Insert ActiveSupport's `underscore` inline here.
      described_class.to_s.underscore.to_sym
    end
    alias_method :me, :described_sym
  end

  # Activate.
  defined?(RSpec) && RSpec.respond_to?(:configure) and RSpec.configure do |config|
    config.include DescribedSym
  end
end; end
