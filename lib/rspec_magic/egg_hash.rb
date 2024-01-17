
"LODoc"

# AF: TODO: Fin.

module RSpecMagic
  # A +Hash+ whose values can "hatch" when needed.
  #
  # There are cases when one needs to pass a +#inspect+-able hash of attributes,
  # which values' computation needs to be put off until the right moment.
  #
  # Траляля, "germ" выглядит вот так: <tt>["show-it", -> { do_computation }]</tt>.
  #
  # = Usage
  #
  # Траляля, тут про +context_when+ и +shared_examples+, мы же про RSpec.
  #
  # = Features
  #
  # == More readable "smart" +#inspect+ format by default
  #
  # Hehe, haha.
  #
  # @todo Дописал LODoc.
  class EggHash < Hash
    # AF: TODO: Всё как с дурацкими логами -- теперь надо морочиться предусматривать основные типы множеств.

    # AF: TODO: Implement.
    # Здесь придётся предусматривать простую рекурсию.
    #def initialize
    #end

    # Build a new object with all "germ" values computed.
    #
    #   h = EggHash[name: "Joe", age: ["?", -> { 20 + 5 }]].hatch
    #   # => { name: "Joe", age: 25 }
    #
    # @return [EggHash]
    def hatch
      self.class[
        *map do |k, v|
          [
            k,
            is_a_germ(v) ? v[1].call : (v.is_a?(self.class) ? v.hatch : v),
          ]
        end.flatten(1)
      ]
    end

    def inspect
      traditional?? inspect_tranditional : inspect_smart
    end

    #--------------------------------------- Class methods

    # AF: TODO: Implement.
    # Возможно, не понадобится. Проверить, когда будет готов `initialize`.
    # def self.[](*args)
    # end

    # "Incubate" an outer object, to let any injected +EggHash+ values hatch.
    # @param [mixed] obj Just any outer object.
    # @return [mixed]
    def self.incubate(obj)
      raise "iniy"
    end

    #---------------------------------------
    private

    # Format a +Symbol+ for smart mode output.
    #
    #   format_symbol(:kk)    # => "kk"
    #   format_symbol()
    #
    # @param [Symbol] sym
    # @return [String]
    def format_sym(sym)
      (s = sym.to_s).empty? || s.index(" ") ? sym.inspect : s
    end

    # @return [String]
    def inspect_smart
      pcs = map do |k, v|
        [
          k.is_a?(Symbol) ? "#{format_sym(k)}: " : "#{k.inspect} => ",
          is_a_germ(v) ? "-> { #{v[0]} }" : v.inspect,
        ].join
      end

      [
        "{",
        (" " + pcs.join(", ") + " " unless pcs.empty?),
        "}",
      ].join
    end

    # @return [String]
    def inspect_traditional
      raise "iniy"
    end

    # Return +true+ if +v+ is a germ.
    # @param [mixed] v
    def is_a_germ(v)
      v.respond_to?(:[]) \
        && v.size == 2 \
        && v[0].is_a?(String) \
        && v[1].is_a?(Proc)
    end

    def traditional?
      # AF: TODO: Fin.
      false
    end
  end
end

#
# Implementation notes:
#
# * We deliberately don't touch the `#to_s`.
