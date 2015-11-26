require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'raise_exception'

matcher = Matchi::Matchers::RaiseException::Matcher.new(ZeroDivisionError)

# It is expected to be true
fail unless matcher.matches? { 0 / 0 }

# It is expected to be false
fail if matcher.matches? { 'bar' }

# It is expected to raise
begin
  matcher.matches? { BOOM }
rescue NameError
  true
end

# It returns this string
fail unless matcher.to_s == 'raise_exception ZeroDivisionError'

# It returns this hash
fail unless matcher.to_h == { RaiseException: [ZeroDivisionError] }
