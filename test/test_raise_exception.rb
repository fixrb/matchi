require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'raise_exception'
require_relative 'helper'

subject 'raise exception built-in matcher' do
  Matchi::RaiseException.new(ZeroDivisionError)
end

it 'must raise the expected exception' do
  @object.matches? { 0 / 0 }.equal?(true)
end

it 'must not raise any exceptions' do
  @object.matches? { 42 }.equal?(false)
end

it 'must raise NameError' do
  begin
    @object.matches? { BOOM }
  rescue NameError
    true
  end
end
