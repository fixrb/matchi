require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'

# It is expected to be true
fail unless Matchi.fetch(:RaiseException, ZeroDivisionError).matches? { 0 / 0 }

# It is expected to be false
fail if Matchi.fetch(:RaiseException, ZeroDivisionError).matches? { 'bar' }

# It is expected to raise
begin
  Matchi.fetch(:RaiseException, ZeroDivisionError).matches? { BOOM }
rescue NameError
  true
end
