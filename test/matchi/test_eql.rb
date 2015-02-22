require_relative File.join '..', 'support', 'coverage'
require_relative File.join '..', '..', 'lib', 'matchi', 'eql'
require_relative 'helper'

subject 'eql built-in matcher' do
  Matchi::Eql.new('foo')
end

it 'must be eql' do
  @object.matches? { 'foo' }.equal?(true)
end

it 'must not be eql' do
  @object.matches? { 'bar' }.equal?(false)
end
