require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'

matcher = Matchi::Equal.new(:foo)

# It is expected to be true
fail unless matcher.matches? { :foo }

# It is expected to be false
fail if matcher.matches? { :bar }

# It returns this string
fail unless matcher.to_s == 'equal :foo'

# It returns this hash
fail unless matcher.to_h == { Equal: [:foo] }
