
# AF: TODO: Fin desc.

module RSpecMagic
  # An +Object+ with a custom +#inspect+ representation.
  # Useful for making "tagged" objects which look meaningful in RSpec doc-like output.
  #
  #   ObjectLooksLike.new("~<DateTime>").inspect
  #   # Returns "~<DateTime>".
  #
  class ObjectLooksLike < Object
    # @param [String] look
    def initialize(look)
      self.instance_eval do
        define_singleton_method(:inspect) { look }
      end
    end
  end
end
