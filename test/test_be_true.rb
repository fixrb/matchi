require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'

# It is expected to be true
fail unless Matchi.fetch(:BeTrue).matches? { true }

# It is expected to be false
fail if Matchi.fetch(:BeTrue).matches? { 'foo' }
