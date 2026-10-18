# frozen_string_literal: true

require_relative File.join("support", "coverage")
require_relative File.join("..", "lib", "matchi", "raise_exception")

# With a class.
matcher = Matchi::RaiseException.new(ZeroDivisionError)
raise unless matcher.match? { 1 / 0 }
raise if matcher.match? { 1 / 1 }
raise if matcher.match? { raise IOError }
raise unless matcher.to_s == "raise exception ZeroDivisionError"

# Descendants pass.
raise unless Matchi::RaiseException.new(StandardError).match? { 1 / 0 }

begin
  raise "SystemExit not caught" unless Matchi::RaiseException.new(Exception).match? { raise SystemExit }
rescue SystemExit
  raise "SystemExit escaped the matcher"
end
raise unless Matchi::RaiseException.new(Interrupt).match? { raise Interrupt }

# With an expected message: exact String, or Regexp.
raise unless Matchi::RaiseException.new(ZeroDivisionError, "divided by 0").match? { 1 / 0 }
raise unless Matchi::RaiseException.new(ZeroDivisionError, /by 0/).match? { 1 / 0 }
raise if Matchi::RaiseException.new(ZeroDivisionError, "divided by").match? { 1 / 0 }
raise if Matchi::RaiseException.new(ZeroDivisionError, /by 1/).match? { 1 / 0 }
raise if Matchi::RaiseException.new(IOError, /by 0/).match? { 1 / 0 }

with_regexp = Matchi::RaiseException.new(ZeroDivisionError, /by 0/)
raise unless with_regexp.to_s == "raise exception ZeroDivisionError with message /by 0/"

with_string = Matchi::RaiseException.new(ZeroDivisionError, "x")
raise unless with_string.to_s == 'raise exception ZeroDivisionError with message "x"'

[42, :symbol, [], Object.new].each do |message|
  Matchi::RaiseException.new(StandardError, message)
  raise "expected ArgumentError for #{message.inspect}"
rescue ArgumentError
  nil
end

# The message is what the exception answers to `message`, overridden or not.
class MatchiTestCustomMessageError < StandardError
  def message = "custom"
end
raise unless Matchi::RaiseException.new(StandardError, "custom").match? { raise MatchiTestCustomMessageError, "raw" }

# A message with an invalid or incompatible encoding does not match, and does not raise.
raise if Matchi::RaiseException.new(StandardError, /x/).match? { raise "a\xff" }
raise if Matchi::RaiseException.new(StandardError, /é/).match? { raise "\xC3\xA9".b }
raise unless Matchi::RaiseException.new(StandardError).match? { raise "a\xff" }

# An exception whose message is not a String does not match a message.
class MatchiTestOddMessageError < StandardError
  def message = 42
end
raise if Matchi::RaiseException.new(StandardError, "42").match? { raise MatchiTestOddMessageError }
raise unless Matchi::RaiseException.new(StandardError).match? { raise MatchiTestOddMessageError }

# With a name, resolved when the matcher runs.
raise unless Matchi::RaiseException.new(:ZeroDivisionError).match? { 1 / 0 }
raise unless Matchi::RaiseException.new("Errno::ENOENT").match? { File.read("/matchi/missing") }

# match? answers false, not nil, for an unrelated exception.
raise unless false.equal?(matcher.match? { raise IOError })

# The exception cannot lie about its class: the expected class receives the comparison.
class MatchiTestLiarError < StandardError
  def class = ZeroDivisionError
  def is_a?(_klass) = true
  def self.<=(_other) = true
  def self.<(_other) = true
end
raise if Matchi::RaiseException.new(ZeroDivisionError).match? { raise MatchiTestLiarError }

# A name resolving to no constant is a NameError when the matcher runs.
begin
  Matchi::RaiseException.new("MatchiTestMissingError").match? { nil }
  raise "expected NameError"
rescue NameError
  nil
end

# An anonymous exception class has a stable description.
raise unless Matchi::RaiseException.new(Class.new(StandardError)).to_s == "raise exception an anonymous class"

# Only exception classes are accepted: a class is checked at construction,
# a name when the matcher runs.
[String, Comparable, "lower", nil, 42].each do |expected|
  Matchi::RaiseException.new(expected)
  raise "expected ArgumentError for #{expected.inspect}"
rescue ArgumentError
  nil
end

%w[String Comparable].each do |name|
  Matchi::RaiseException.new(name).match? { nil }
  raise "expected TypeError for #{name}"
rescue TypeError
  nil
end

# A block is required.
begin
  matcher.match?
  raise "expected ArgumentError"
rescue ArgumentError => e
  raise unless e.message == "a block must be provided"
end
