# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi")

# Every matcher is loaded, follows the same interface, and answers true or
# false (never nil) on a passing and on a failing value.
matchers = {
  Matchi::Be.new(1)                             => [1, 2],
  Matchi::BeAKindOf.new(Integer)                => [1, "1"],
  Matchi::BeAnInstanceOf.new(Integer)           => [1, 1.0],
  Matchi::BeWithin.new(1).of(1)                 => [2, 3],
  Matchi::Change.new([], :length)               => nil,
  Matchi::Eq.new(1)                             => [1, 2],
  Matchi::Match.new(/1/)                        => %w[1 2],
  Matchi::Predicate.new(:be_positive)           => [1, -1],
  Matchi::RaiseException.new(ZeroDivisionError) => nil,
  Matchi::Satisfy.new { |value| value == 1 }    => [1, 2]
}

matchers.each do |matcher, values|
  name = matcher.class.name
  raise name unless matcher.respond_to?(:match?)
  raise name unless matcher.method(:match?).arity.zero?
  raise name unless matcher.to_s.is_a?(String) && !matcher.to_s.include?("#<")

  next if values.nil?

  passing, failing = values
  raise "#{name} did not pass" unless true.equal?(matcher.match? { passing })
  raise "#{name} did not fail" unless false.equal?(matcher.match? { failing })
end

list = []
raise unless true.equal?(Matchi::Change.new(list, :length).match? { list << 1 })
raise unless false.equal?(Matchi::Change.new(list, :length).match? { nil })
raise unless true.equal?(Matchi::Change.new(list, :length).by(1).match? { list << 1 })
raise unless false.equal?(Matchi::Change.new(list, :length).by(1).match? { nil })
raise unless true.equal?(Matchi::Change.new(list, :length).to(3).match? { list << 1 })
raise unless false.equal?(Matchi::Change.new(list, :length).to(3).match? { nil })
raise unless true.equal?(Matchi::Change.new(list, :length).from(3).to(4).match? { list << 1 })
raise unless false.equal?(Matchi::Change.new(list, :length).from(3).to(4).match? { nil })
raise unless true.equal?(Matchi::RaiseException.new(ZeroDivisionError).match? { 1 / 0 })
raise unless false.equal?(Matchi::RaiseException.new(ZeroDivisionError).match? { nil })

# The helper module of the 4.x series is gone: Matchi is a namespace.
raise if Matchi.respond_to?(:eq) || Matchi.instance_methods.any?
