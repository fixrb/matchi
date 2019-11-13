# frozen_string_literal: true

require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'raise_exception'

matcher = Matchi::Matchers::RaiseException::Matcher.new(ZeroDivisionError)

# It is expected to be true
raise unless matcher.matches? { 0 / 0 }

# It is expected to be false
raise if matcher.matches? { 'bar' }

# It is expected to raise
begin
  matcher.matches? { Matchi::BOOM }
  raise
rescue NameError
  true
end

# It returns this string
raise unless matcher.to_s == 'raise_exception ZeroDivisionError'

# It returns this representation
raise unless matcher.inspect == 'RaiseException(ZeroDivisionError)'

# It returns this hash
raise unless matcher.to_h == { RaiseException: [ZeroDivisionError] }
