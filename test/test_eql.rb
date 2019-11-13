# frozen_string_literal: true

require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers', 'eql'

matcher = Matchi::Matchers::Eql::Matcher.new('foo')

# It is expected to be true
raise unless matcher.matches? { 'foo' }

# It is expected to be false
raise if matcher.matches? { 'bar' }

# It returns this string
raise unless matcher.to_s == 'eql "foo"'

# It returns this representation
raise unless matcher.inspect == 'Eql("foo")'

# It returns this hash
raise unless matcher.to_h == { Eql: ['foo'] }
