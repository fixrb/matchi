require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'

# It is expected to be true
module Matchi
  class Foo; end
end

fail unless Matchi.constants.to_set.superset? [
  :BeFalse, :BeNil, :BeTrue, :Eql, :Equal, :Match, :RaiseException
].to_set
