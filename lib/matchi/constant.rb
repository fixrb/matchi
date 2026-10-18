# frozen_string_literal: true

module Matchi
  # Shared handling of an expected module given directly or by name.
  #
  # A name is a String or a Symbol holding a constant path such as
  # `"Comparable"` or `:"Foo::Bar"`. It is validated when the matcher is built
  # and resolved from `Object` when the matcher runs, which lets a
  # specification be written before the class it describes is loaded. Since
  # resolution goes through `Object.const_get`, an `autoload` or an
  # `Object.const_missing` defined by the code under test takes part in it.
  #
  # @api private
  module Constant
    # A constant path: ASCII segments that start with a capital letter,
    # joined by `::`, such as `"Comparable"` or `"File::Stat"`.
    NAME = /\A[A-Z]\w*(::[A-Z]\w*)*\z/

    # @param expected [Module, String, Symbol] a module, or its name
    # @param kind [Class] `Module` or `Class`, what expected must be
    # @return [Module, String] the module itself, or the validated name
    # @raise [ArgumentError] when expected is neither
    def self.normalize(expected, kind)
      return expected if kind === expected
      return String(expected) if (::String === expected || ::Symbol === expected) && NAME.match?(expected)

      raise ::ArgumentError, "expected must be a #{kind} or a constant name (got: #{expected.inspect})"
    end

    # @param expected [Module, String] a module, or a validated name
    # @return [String] the name, or a stable label for an anonymous module
    #
    # The name is read with `Module#name` bound to the module, so a class
    # of the code under test that redefines `name` cannot break a report.
    def self.label(expected)
      return expected unless ::Module === expected

      ::Module.instance_method(:name).bind_call(expected) || "an anonymous #{::Class === expected ? "class" : "module"}"
    end

    # @param expected [Module, String] a module, or a validated name
    # @param kind [Class] `Module` or `Class`, what the name must resolve to
    # @return [Module]
    # @raise [NameError] when the name is not defined
    # @raise [TypeError] when the name does not resolve to the expected kind
    def self.resolve(expected, kind)
      return expected if kind === expected

      value = ::Object.const_get(expected)
      raise ::TypeError, "#{expected} is not a #{kind}" unless kind === value

      value
    end
  end
end
