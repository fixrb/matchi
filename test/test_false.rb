require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'be_false'
require_relative 'helper'

subject 'be_false built-in matcher' do
  Matchi::BeFalse.new
end

it 'must be false' do
  @object.matches? { false }.equal?(true)
end

it 'must not be false' do
  @object.matches? { 'foo' }.equal?(false)
end
