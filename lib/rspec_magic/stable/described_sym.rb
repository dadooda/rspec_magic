# frozen_string_literal: true

"LODoc"

module RSpecMagic; module Stable
  # Transform +described_class+ into underscored symbols +described_sym+ and +me+.
  #
  #   describe UserProfile do
  #     it { expect(described_sym).to eq :user_profile }
  #     it { expect(me).to eq :user_profile }
  #   end
  #
  # With a factory:
  #
  #   describe UserProfile do
  #     let(:uprof1) { create described_sym }
  #     let(:uprof2) { create me }
  #     …
  #   end
  module DescribedSym
    module Exports
      # A +Symbol+ representation of +described_class+.
      # @return [Symbol] E.g. +:user_profile+.
      def described_sym
        Util.underscore(described_class.to_s).to_sym
      end
      alias_method :me, :described_sym
    end # Exports

    # Utilities.
    module Util
      # Generate an underscored, lowercase representation of a camel-cased word.
      # <tt>"::"</tt>s are converted to <tt>"/"</tt>s.
      #
      #   underscore("ActiveModel")         # => "active_model"
      #   underscore("ActiveModel::Errors") # => "active_model/errors"
      #
      # NOTE: This method has been ported from ActiveSupport, mostly as is.
      #
      # @param [String] camel_cased_word
      # @return [Symbol]
      def self.underscore(camel_cased_word)
        # Unlike ActiveSupport, we don't support acronyms.
        acronym_regex = /(?=a)b/

        word = camel_cased_word.to_s.dup
        word.gsub!(/::/, '/')
        word.gsub!(/(?:([A-Za-z\d])|^)(#{acronym_regex})(?=\b|[^a-z])/) { "#{$1}#{$1 && '_'}#{$2.downcase}" }
        word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
        word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
        word.tr!("-", "_")
        word.downcase!
        word
      end
    end
  end # module

  # Activate.
  defined?(RSpec) && RSpec.respond_to?(:configure) and RSpec.configure do |config|
    config.include DescribedSym::Exports
  end
end; end
