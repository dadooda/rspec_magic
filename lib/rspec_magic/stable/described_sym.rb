# frozen_string_literal: true

# TODO: CUP.
require "active_support"

module RSpecMagic; module Stable
  # Transform <tt>described_class</tt> into an underscored symbol.
  #
  # = Usage
  #
  #   describe UserProfile do
  #     it { expect(described_sym).to eq :user_profile }
  #     it { expect(me).to eq :user_profile }
  #   end
  #
  # With a factory:
  #
  #   describe UserProfile do
  #     let(:obj1) { create described_sym }
  #     let(:obj2) { create me }
  #     …
  #   end
  module DescribedSym
    module Exports
      # @return [Symbol]
      def described_sym
        klass_name = "CSVEntry"

        # p "ActiveSupport::Inflector.inflections.acronym_regex", ActiveSupport::Inflector.inflections.acronym_regex
        # p "ActiveSupport::Inflector.inflections.acronyms", ActiveSupport::Inflector.inflections.acronyms
        # # TODO: Fin.

        # usc = ActiveSupport::Inflector.underscore(klass_name)
        # p "usc", usc

        usca = Util.underscore(klass_name)
        p "usca", usca

        Util.underscore(described_class.to_s).to_sym
      end
      alias_method :me, :described_sym
    end # Exports

    module Util
      # Makes an underscored, lowercase form from the expression in the string.
      # Changes '::' to '/' to convert namespaces to paths.
      #
      #   underscore("ActiveModel")         # => "active_model"
      #   underscore("ActiveModel::Errors") # => "active_model/errors"
      #
      def self.underscore(camel_cased_word)
        # NOTE: This method has been ported from ActiveSupport, mostly as is.

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

# OPTIMIZE: Add tests.
