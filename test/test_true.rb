require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'be_true'
require_relative 'helper'

subject 'be_true built-in matcher' do
  Matchi::BeTrue.new
end

it 'must be true' do
  @object.matches? { true }.equal?(true)
end

it 'must not be true' do
  @object.matches? { 'foo' }.equal?(false)
end
