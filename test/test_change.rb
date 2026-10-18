# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "change")

list = []
matcher = Matchi::Change.new(list, :length)

raise unless matcher.match? { list << 1 }
raise if matcher.match? { list }
raise unless matcher.to_s == "change Array#length"

# Arguments, keyword arguments and a block are forwarded to the observed method.
raise unless Matchi::Change.new(list, :fetch, 0).match? { list[0] = 2 }
raise unless Matchi::Change.new({ a: 1 }, :fetch, :b, "x").to_s == "change Hash#fetch"

counter = Object.new
def counter.count(items, from:) = items.count { |item| yield(item) && item >= from }
raise unless Matchi::Change.new(counter, :count, list, from: 1, &:odd?).match? { list << 3 }

# The method name may be a Symbol or a String.
raise unless Matchi::Change.new(list, "length").match? { list << 1 }
raise unless Matchi::Change.new(list, "length").to_s == "change Array#length"

# The description names the class, never the object's inspect.
loud = Object.new
def loud.inspect = raise("inspect called")
def loud.value = 1
raise unless Matchi::Change.new(loud, :value).to_s == "change Object#value"
raise unless Matchi::Change.new(Class.new.new, :to_s).to_s == "change an anonymous class#to_s"

liar_class = Class.new { def self.name = raise("hostile name") }
raise unless Matchi::Change.new(liar_class.new, :to_s).to_s == "change an anonymous class#to_s"

# Only public methods are observed; a missing or private one is a NoMethodError when the matcher runs.
object = Object.new
def object.secret = 1
object.singleton_class.send(:private, :secret)
%i[secret missing].each do |name|
  Matchi::Change.new(object, name).match? { nil }
  raise "expected NoMethodError for #{name.inspect}"
rescue NoMethodError
  nil
end

# The observed object may be a BasicObject, or lie about respond_to?.
basic = Class.new(BasicObject) { def value = 1 }.new
raise if Matchi::Change.new(basic, :value).match? { nil }

liar = Object.new
def liar.respond_to?(*) = true
def liar.public_send(*) = 1
def liar.value = 2
raise if Matchi::Change.new(liar, :value).match? { nil }

begin
  Matchi::Change.new(list, 42)
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "method must be a Symbol or a String (got: 42)"
end

# The observed method must return a value: the same unfrozen object twice
# cannot be compared, so match? raises instead of answering false.
holder = Object.new
def holder.items = (@items ||= [])
begin
  Matchi::Change.new(holder, :items).match? { holder.items << 1 }
  raise "expected TypeError"
rescue TypeError => e
  raise unless e.message.include?("same unfrozen object")
end

# The same frozen object twice is an unchanged value, whatever it contains.
raise if Matchi::Change.new(:foo, :itself).match? { nil }
raise if Matchi::Change.new("foo", :itself).match? { nil }
raise if Matchi::Change.new(1, :itself).match? { nil }

frozen_container = [[]].freeze
raise if Matchi::Change.new(frozen_container, :itself).match? { frozen_container[0] << 1 }

# by, by_at_least, by_at_most
list = []
raise unless Matchi::Change.new(list, :length).by(2).match? { list.push(1, 2) }
raise if Matchi::Change.new(list, :length).by(2).match? { list.push(1) }
raise unless Matchi::Change.new(list, :length).by(0).match? { list }
raise unless Matchi::Change.new(list, :length).by(-3).match? { list.clear }
raise unless Matchi::Change.new(list, :length).by(1.0).match? { list.push(1) }
raise unless Matchi::Change.new(list, :length).by_at_least(1).match? { list.push(1, 2) }
raise unless Matchi::Change.new(list, :length).by_at_least(2).match? { list.push(1, 2) }
raise if Matchi::Change.new(list, :length).by_at_least(3).match? { list.push(1, 2) }
raise unless Matchi::Change.new(list, :length).by_at_most(3).match? { list.push(1, 2) }
raise unless Matchi::Change.new(list, :length).by_at_most(2).match? { list.push(1, 2) }
raise if Matchi::Change.new(list, :length).by_at_most(1).match? { list.push(1, 2) }
raise unless Matchi::Change.new(list, :length).by_at_most(1).match? { list.clear }
raise unless Matchi::Change.new(list, :length).by(1).to_s == "change by 1"
raise unless Matchi::Change.new(list, :length).by_at_least(1).to_s == "change by at least 1"
raise unless Matchi::Change.new(list, :length).by_at_most(1).to_s == "change by at most 1"
raise unless Matchi::Change.new(list, :length).by(Rational(1, 2)).to_s == "change by (1/2)"

# A non-numeric observed value makes the subtraction fail loudly.
begin
  Matchi::Change.new("a", :to_s).by(1).match? { nil }
  raise "expected NoMethodError"
rescue NoMethodError
  nil
end

# The operator is checked when a Delta is built directly.
begin
  Matchi::Change::Delta.new(:by_exactly, 1) { 0 }
  raise "expected ArgumentError"
rescue ArgumentError
  nil
end

# Deltas are finite real numbers; by_at_least and by_at_most are non-negative.
[["1"], [nil], [Float::NAN], [Float::INFINITY], [Complex(1, 0)],
 [-1, :by_at_least], [-1, :by_at_most], [Float::NAN, :by_at_least]].each do |delta, refinement|
  Matchi::Change.new(list, :length).public_send(refinement || :by, delta)
  raise "expected ArgumentError for #{refinement || :by}(#{delta.inspect})"
rescue ArgumentError
  nil
end

# to, from ... to: compared with eql?, like Matchi::Eq, by the expected value.
string = +"a"
raise unless Matchi::Change.new(string, :to_s).to("b").match? { string.replace("b") }
raise if Matchi::Change.new(string, :to_s).to("c").match? { string.replace("b") }
raise if Matchi::Change.new(1, :to_i).to(1.0).match? { nil }
raise unless Matchi::Change.new(string, :to_s).to("b").to_s == 'change to "b"'

# `to` demands a change: a value already there does not pass, and the block
# is evaluated anyway.
evaluated = false
raise if Matchi::Change.new("b", :to_s).to("b").match? { evaluated = true }
raise unless evaluated

# `to` and `from … to` compare like Eq: a Hash liar does not pass.
hash_liar = Object.new
def hash_liar.respond_to?(name, *) = name == :to_hash
def hash_liar.eql?(_other) = true
raise if Matchi::Change.new([hash_liar], :first).to({ a: 1 }).match? { nil }
raise if Matchi::Change.new([hash_liar], :first).from({ a: 1 }).to({ b: 2 }).match? { nil }

# `from ... to` evaluates the block even when the initial value is wrong.
string = +"a"
evaluated = false
raise if Matchi::Change.new(string, :to_s).from("x").to("b").match? { evaluated = true }
raise unless evaluated

liar = Object.new
def liar.eql?(_other) = true
def liar.==(_other) = true
def liar.value = self
raise if Matchi::Change.new(liar, :value).to("b").match? { nil }
raise if Matchi::Change.new(liar, :value).from("a").to("b").match? { nil }

two_faced = Object.new
def two_faced.value = (@calls = (@calls || 0) + 1) == 1 ? "a" : self
def two_faced.eql?(_other) = true
raise if Matchi::Change.new(two_faced, :value).from("a").to("b").match? { nil }

string = +"a"
raise unless Matchi::Change.new(string, :to_s).from("a").to("b").match? { string.replace("b") }

string = +"a"
raise if Matchi::Change.new(string, :to_s).from("x").to("b").match? { string.replace("b") }

string = +"a"
raise if Matchi::Change.new(string, :to_s).from("a").to("c").match? { string.replace("b") }
raise unless Matchi::Change.new(string, :to_s).from("a").to("b").to_s == 'change from "a" to "b"'

# Without `to`, `from` is not a matcher, but it has a description.
raise if Matchi::Change.new(string, :to_s).from("a").respond_to?(:match?)
raise unless Matchi::Change.new(string, :to_s).from("a").to_s == 'change from "a"'

# A block is required, by every matcher and by the classes the refinements build.
[
  matcher,
  Matchi::Change.new(list, :length).by(1),
  Matchi::Change.new(list, :length).to(1),
  Matchi::Change.new(list, :length).from(0).to(1)
].each do |refined|
  refined.match?
  raise "expected ArgumentError for #{refined}"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end

[
  -> { Matchi::Change::Delta.new(:by, 1) },
  -> { Matchi::Change::From.new(0) },
  -> { Matchi::Change::FromTo.new(0, 1) },
  -> { Matchi::Change::To.new(1) }
].each do |build|
  build.call
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end
