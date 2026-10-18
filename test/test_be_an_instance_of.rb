# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be_an_instance_of")

# With a class.
matcher = Matchi::BeAnInstanceOf.new(Integer)
raise unless matcher.match? { 42 }
raise if matcher.match? { 4.2 }
raise unless matcher.to_s == "be an instance of Integer"

# Exact class only, not an ancestor.
raise if Matchi::BeAnInstanceOf.new(Numeric).match? { 42 }

# With an anonymous class.
klass = Class.new
raise unless Matchi::BeAnInstanceOf.new(klass).match? { klass.new }
raise if Matchi::BeAnInstanceOf.new(klass).match? { Class.new(klass).new }

# With a name, resolved when the matcher runs.
raise unless Matchi::BeAnInstanceOf.new(:Integer).match? { 42 }
raise unless Matchi::BeAnInstanceOf.new("File::Stat").match? { File.stat(__FILE__) }

# The actual value cannot lie, and a BasicObject is handled.
liar = Object.new
def liar.class = String
def liar.instance_of?(_klass) = true
raise if Matchi::BeAnInstanceOf.new(String).match? { liar }
raise unless Matchi::BeAnInstanceOf.new(BasicObject).match? { BasicObject.new }

# An anonymous class has a stable description.
raise unless Matchi::BeAnInstanceOf.new(klass).to_s == "be an instance of an anonymous class"

# Only a class can have instances: a module is rejected, directly or by name.
["integer", Comparable, nil].each do |expected|
  Matchi::BeAnInstanceOf.new(expected)
  raise "expected ArgumentError for #{expected.inspect}"
rescue ArgumentError
  nil
end

%w[Comparable RUBY_VERSION].each do |name|
  Matchi::BeAnInstanceOf.new(name).match? { 42 }
  raise "expected TypeError for #{name}"
rescue TypeError
  nil
end

begin
  Matchi::BeAnInstanceOf.new("MatchiTestMissingClass").match? { 42 }
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
