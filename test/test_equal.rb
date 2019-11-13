# frozen_string_literal: true

require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'equal'

matcher = Matchi::Matchers::Equal::Matcher.new(:foo)

# It is expected to be true
raise unless matcher.matches? { :foo }

# It is expected to be false
raise if matcher.matches? { :bar }

# It returns this string
raise unless matcher.to_s == 'equal :foo'

# It returns this representation
raise unless matcher.inspect == 'Equal(:foo)'

# It returns this hash
raise unless matcher.to_h == { Equal: [:foo] }
