require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi'
require_relative 'helper'

subject 'Matchi module' do
  Matchi
end

it 'fetch be_true matcher' do
  @object.fetch(:BeTrue).matches? { true }
end

it 'fetch eql matcher' do
  @object.fetch(:Eql, 'foo').matches? { 'foo' }
end

it 'fail with local jump error if no block given' do
  begin
    @object.fetch(:BeTrue).matches?
  rescue LocalJumpError
    true
  end
end

it 'fail with argument error if an argument is missing' do
  begin
    @object.fetch(:Eql).matches? { 42 }
  rescue ArgumentError
    true
  end
end

it 'fail with name error if the matcher is an ancestor' do
  begin
    @object.fetch(:Object).matches? { 42 }
  rescue NameError
    true
  end
end

it 'fail with name error if the matcher does not exist' do
  begin
    @object.fetch(:MatcherNotFound).matches? { 42 }
  rescue NameError
    true
  end
end
