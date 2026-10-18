# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "predicate")

# be_xxx calls xxx?
matcher = Matchi::Predicate.new(:be_empty)
raise unless matcher.match? { [] }
raise if matcher.match? { [1] }
raise unless matcher.to_s == "be empty"

# The name may be a String.
raise unless Matchi::Predicate.new("be_empty").match? { [] }

# have_xxx calls has_xxx?
matcher = Matchi::Predicate.new(:have_key, :foo)
raise unless matcher.match? { { foo: 1 } }
raise if matcher.match? { { bar: 1 } }
raise unless matcher.to_s == "have key :foo"

# have_xxx calls has_xxx?, not xxx?.
object = Object.new
def object.has_wings? = true # rubocop:disable Naming/PredicatePrefix
def object.wings? = false
raise unless Matchi::Predicate.new(:have_wings).match? { object }

# Keyword arguments and a block are forwarded.
object = Object.new
def object.ready?(level:) = yield(level)
raise unless Matchi::Predicate.new(:be_ready, level: 2) { |level| level > 1 }.match? { object }
raise unless Matchi::Predicate.new(:be_ready, level: 2) { |_| true }.to_s == "be ready level: 2, &block"
raise unless Matchi::Predicate.new(:have_key, :a, :b, c: 1).to_s == "have key :a, :b, c: 1"

# Only public predicates are called.
object = Object.new
def object.secret? = true
object.singleton_class.send(:private, :secret?)
begin
  Matchi::Predicate.new(:be_secret).match? { object }
  raise "expected NoMethodError"
rescue NoMethodError
  nil
end

# The predicate is reached through Kernel#public_send, whatever the object says.
liar = Object.new
def liar.public_send(*) = true # rubocop:disable Naming/PredicateMethod
def liar.empty? = false
raise if Matchi::Predicate.new(:be_empty).match? { liar }

begin
  Matchi::Predicate.new(:be_empty).match? { BasicObject.new }
  raise "expected NoMethodError"
rescue NoMethodError => e
  raise unless e.message.include?("empty?")
end

# The predicate must answer true or false, not a truthy value; the error
# names the class of the answer, never its inspect.
object = Object.new
def object.sloppy? = 1 # rubocop:disable Naming/PredicateMethod
def object.quiet? = nil # rubocop:disable Naming/PredicateMethod, Style/ReturnNilInPredicateMethodDefinition
begin
  Matchi::Predicate.new(:be_sloppy).match? { object }
  raise "expected TypeError"
rescue TypeError => e
  raise unless e.message == "sloppy? must return true or false (got a Integer)"
end
begin
  Matchi::Predicate.new(:be_quiet).match? { object }
  raise "expected TypeError"
rescue TypeError
  nil
end
bomb = Object.new
def bomb.inspect = raise("inspect bomb")
object.define_singleton_method(:bomb?) { bomb }
begin
  Matchi::Predicate.new(:be_bomb).match? { object }
  raise "expected TypeError"
rescue TypeError
  nil
end

# Any letter is allowed in a name, not only ASCII.
object = Object.new
def object.vidé? = true
raise unless Matchi::Predicate.new(:be_vidé).match? { object }

# The name must start with be_ or have_ and must not end with ? or !.
%i[empty? be_empty? have_key! is_empty be_ be_1].each do |name| # rubocop:disable Naming/VariableNumber
  Matchi::Predicate.new(name)
  raise "expected ArgumentError for #{name.inspect}"
rescue ArgumentError
  nil
end

# A block is required.
begin
  matcher.match?
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end
