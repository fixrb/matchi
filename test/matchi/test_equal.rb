require_relative File.join '..', 'support', 'coverage'
require_relative File.join '..', '..', 'lib', 'matchi', 'equal'
require_relative 'helper'

subject 'equal built-in matcher' do
  Matchi::Equal.new(:foo)
end

it 'must be equal' do
  @object.matches? { :foo }.equal?(true)
end

it 'must not be equal' do
  @object.matches? { :bar }.equal?(false)
end
