require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'

# It is expected to be true
fail unless Matchi.fetch(:Equal, :foo).matches? { :foo }

# It is expected to be false
fail if Matchi.fetch(:Equal, :foo).matches? { :bar }
