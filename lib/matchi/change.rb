# frozen_string_literal: true

require_relative File.join("change", "by_at_least")
require_relative File.join("change", "by_at_most")
require_relative File.join("change", "by")
require_relative File.join("change", "from")
require_relative File.join("change", "to")

module Matchi
  # Wraps the target of a change matcher.
  class Change
    # Initialize a wrapper of the change matcher with an object and the name of
    # one of its methods.
    #
    # @example
    #   require "matchi/change"
    #
    #   Matchi::Change.new("foo", :to_s)
    #
    # @param object [#object_id]  An object.
    # @param method [Symbol]      The name of a method.
    # @param args   [Array]       A list of arguments.
    # @param kwargs [Hash]        A list of keyword arguments.
    def initialize(object, method, *args, **kwargs, &block)
      @state = -> { object.send(method, *args, **kwargs, &block) }
    end

    # Specifies a minimum delta of the expected change.
    #
    # @example
    #   require "matchi/change"
    #
    #   object = []
    #
    #   change_wrapper = Matchi::Change.new(object, :length)
    #   change_wrapper.by_at_least(1)
    #
    # @param expected [#object_id] The minimum delta of the expected change.
    #
    # @return [#matches?] A *change by at least* matcher.
    def by_at_least(expected)
      ByAtLeast.new(expected, &@state)
    end

    # Specifies a maximum delta of the expected change.
    #
    # @example
    #   require "matchi/change"
    #
    #   object = []
    #
    #   change_wrapper = Matchi::Change.new(object, :length)
    #   change_wrapper.by_at_most(1)
    #
    # @param expected [#object_id] The maximum delta of the expected change.
    #
    # @return [#matches?] A *change by at most* matcher.
    def by_at_most(expected)
      ByAtMost.new(expected, &@state)
    end

    # Specifies the delta of the expected change.
    #
    # @example
    #   require "matchi/change"
    #
    #   object = []
    #
    #   change_wrapper = Matchi::Change.new(object, :length)
    #   change_wrapper.by(1)
    #
    # @param expected [#object_id] The delta of the expected change.
    #
    # @return [#matches?] A *change by* matcher.
    def by(expected)
      By.new(expected, &@state)
    end

    # Specifies the original value.
    #
    # @example
    #   require "matchi/change"
    #
    #   change_wrapper = Matchi::Change.new("foo", :to_s)
    #   change_wrapper.from("foo")
    #
    # @param expected [#object_id] The original value.
    #
    # @return [#matches?] A *change from* wrapper.
    def from(expected)
      From.new(expected, &@state)
    end

    # Specifies the new value to expect.
    #
    # @example
    #   require "matchi/change"
    #
    #   change_wrapper = Matchi::Change.new("foo", :to_s)
    #   change_wrapper.to("FOO")
    #
    # @param expected [#object_id] The new value to expect.
    #
    # @return [#matches?] A *change to* matcher.
    def to(expected)
      To.new(expected, &@state)
    end
  end
end
