# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be_a_kind_of")

# With a module.
matcher = Matchi::BeAKindOf.new(Numeric)
raise unless matcher.match? { 42 }
raise unless matcher.match? { 4.2 }
raise if matcher.match? { "42" }
raise unless matcher.to_s == "be a kind of Numeric"

raise unless Matchi::BeAKindOf.new(Comparable).match? { 42 }

# With an anonymous class or module, described without a memory address.
klass = Class.new
raise unless Matchi::BeAKindOf.new(klass).match? { Class.new(klass).new }
raise if Matchi::BeAKindOf.new(klass).match? { Object.new }
raise unless Matchi::BeAKindOf.new(klass).to_s == "be a kind of an anonymous class"
raise unless Matchi::BeAKindOf.new(Module.new).to_s == "be a kind of an anonymous module"

# Matchi::Constant keeps its own name: the helper is called `label`.
raise unless Matchi::Constant.name == "Matchi::Constant"
raise unless Matchi::Constant.label("Foo") == "Foo"

# With a name, resolved when the matcher runs.
raise unless Matchi::BeAKindOf.new(:Numeric).match? { 42 }
raise unless Matchi::BeAKindOf.new("File::Stat").match? { File.stat(__FILE__) }
raise unless Matchi::BeAKindOf.new("Numeric").to_s == "be a kind of Numeric"

late = Matchi::BeAKindOf.new(:MatchiTestLateClass)
class MatchiTestLateClass; end # rubocop:disable Lint/EmptyClass
raise unless late.match? { MatchiTestLateClass.new }

# The actual value cannot lie.
liar = Object.new
def liar.is_a?(_mod) = true
def liar.kind_of?(_mod) = true
raise if Matchi::BeAKindOf.new(String).match? { liar }
raise unless Matchi::BeAKindOf.new(BasicObject).match? { BasicObject.new }

# A name must be a constant path.
["string", "Object::lower", "42", "Foo;Bar", "::Object", "Object::", nil, 42].each do |name|
  Matchi::BeAKindOf.new(name)
  raise "expected ArgumentError for #{name.inspect}"
rescue ArgumentError
  nil
end

# A name must resolve to a module.
begin
  Matchi::BeAKindOf.new("RUBY_VERSION").match? { RUBY_VERSION }
  raise "expected TypeError"
rescue TypeError
  nil
end

begin
  Matchi::BeAKindOf.new("MatchiTestMissingClass").match? { nil }
  raise "expected NameError"
rescue NameError
  nil
end

# A block is required.
begin
  matcher.match?
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end
