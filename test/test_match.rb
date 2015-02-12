require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'match'
require_relative 'helper'

subject 'match built-in matcher' do
  Matchi::Match.new(/^foo/)
end

it 'must match the string' do
  @object.matches? { 'foobar' }.equal?(true)
end

it 'must not match the string' do
  @object.matches? { 'bar' }.equal?(false)
end
