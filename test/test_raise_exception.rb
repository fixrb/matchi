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

# The exceptions a block raises on its own, a StandardError, a ScriptError,
# a SystemStackError or a SystemExit, are caught and judged whatever the
# expected class.
recurse = nil
recurse = -> { recurse.call }
begin
  raise unless Matchi::RaiseException.new(SystemExit).match? { exit 3 }
  raise unless Matchi::RaiseException.new(Exception).match? { exit 3 }
  raise if matcher.match? { exit 3 }
rescue SystemExit
  raise "SystemExit escaped the matcher"
end
raise unless Matchi::RaiseException.new(NotImplementedError).match? { raise NotImplementedError }
raise if matcher.match? { raise NotImplementedError }
raise unless Matchi::RaiseException.new(SystemStackError).match? { recurse.call }
raise if matcher.match? { recurse.call }

# Any other exception goes through, unless it is the one expected; the
# message still has to match.
[Interrupt, NoMemoryError, SecurityError].each do |klass|
  begin
    matcher.match? { raise klass }
    raise "expected #{klass} to go through"
  rescue klass
    nil
  end
  raise unless Matchi::RaiseException.new(klass).match? { raise klass }
  raise unless Matchi::RaiseException.new(Exception).match? { raise klass }
  raise unless false.equal?(Matchi::RaiseException.new(klass, "nope").match? { raise klass, "yes" })
end
begin
  matcher.match? { raise SignalException, "TERM" }
  raise "expected the signal to go through"
rescue SignalException
  nil
end
# An enclosing Timeout ends the block with its own exception, which goes
# through; a Timeout given a StandardError to raise, or one inside the
# block, raises what the matcher judges.
require "timeout"
begin
  Timeout.timeout(0.05) { matcher.match? { sleep } }
  raise "expected the timeout to go through"
rescue Timeout::Error
  nil
end
raise if Timeout.timeout(0.05, RuntimeError) { matcher.match? { sleep } }
raise unless Matchi::RaiseException.new(Timeout::Error).match? { Timeout.timeout(0.05) { sleep } }

# With an expected message: exact String, or Regexp.
raise unless Matchi::RaiseException.new(ZeroDivisionError, "divided by 0").match? { 1 / 0 }
raise unless Matchi::RaiseException.new(ZeroDivisionError, /by 0/).match? { 1 / 0 }
raise unless false.equal?(Matchi::RaiseException.new(ZeroDivisionError, "divided by").match? { 1 / 0 })
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

# What the message filter raises propagates: it is not the block's exception.
class MatchiTestBrokenMessageError < StandardError
  def message = raise(IOError, "broken message")
end
begin
  Matchi::RaiseException.new(StandardError, "x").match? { raise MatchiTestBrokenMessageError }
  raise "expected IOError"
rescue IOError
  nil
end

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

# Nor can the message: the expected String or Regexp receives the
# comparison, on a plain copy of the message.
class MatchiTestLiarMessage < String
  def eql?(_other) = true
  def ==(_other) = true
  def match?(*) = true
  def valid_encoding? = true
end

class MatchiTestLiarMessageError < StandardError
  def message = MatchiTestLiarMessage.new("liar")
end

class MatchiTestInvalidLiarMessageError < StandardError
  def message = MatchiTestLiarMessage.new("a\xff")
end
raise if Matchi::RaiseException.new(StandardError, "x").match? { raise MatchiTestLiarMessageError }
raise if Matchi::RaiseException.new(StandardError, /x/).match? { raise MatchiTestLiarMessageError }
raise if Matchi::RaiseException.new(StandardError, /a/).match? { raise MatchiTestInvalidLiarMessageError }
raise unless Matchi::RaiseException.new(StandardError, /liar/).match? { raise MatchiTestLiarMessageError }

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
