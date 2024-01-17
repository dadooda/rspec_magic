# frozen_string_literal: true

# AF: TODO: Fin.

module RSpecMagic; module Unstable
  # Tralala some description.
  module LooksLike
    module Exports
      # A shorthand form of creating a "look-alike" object.
      # Look-alike objects make specs' code and output more distinct and meaningful.
      #
      #   describe ClientService do
      #     it_behaves_like "instantiatable", client: looks_like("~<Client>")
      #   end
      #
      #   let(:signature) { looks_like "~<ActiveRecord::Relation>" }
      #   it do
      #     expect(client).to receive(:submissions).and_return(signature)
      #     is_expected.to be signature
      #   end
      #
      # @param [String] look
      # @return [RSpecMagic::LooksLike]
      def looks_like(look)
        RSpecMagic::ObjectLooksLike.new(look)
      end
    end # Exports

    # AF: TODO: Activate siblings like here!

    # Activate.
    defined?(RSpec) && RSpec.respond_to?(:configure) and RSpec.configure do |config|
      config.include Exports
      config.extend Exports
    end
  end # module
end; end
