# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "be")

matcher = Matchi::Be.new(:foo)

raise unless matcher.match? { :foo }
raise if matcher.match? { :bar }
raise unless matcher.to_s == "be :foo"

# Identity, not equality.
string = "foo"
raise unless Matchi::Be.new(string).match? { string }
raise if Matchi::Be.new(string).match? { string.dup }

# The actual value cannot lie: the expected value receives the call.
liar = Object.new
def liar.equal?(_other) = true
raise if Matchi::Be.new(:foo).match? { liar }

# A block is required.
begin
  matcher.match?
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end
