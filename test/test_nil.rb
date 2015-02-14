require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'be_nil'
require_relative 'helper'

subject 'be_nil built-in matcher' do
  Matchi::BeNil.new
end

it 'must be nil' do
  @object.matches? { nil }.equal?(true)
end

it 'must not be nil' do
  @object.matches? { 'foo' }.equal?(false)
end
