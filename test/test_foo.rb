# frozen_string_literal: true

require_relative File.join 'support', 'coverage'
require_relative File.join '..', 'lib', 'matchi', 'matchers_base'

module Matchi
  module Matchers
    # **Foo** matcher.
    module Foo
      # The matcher.
      class Matcher
        include MatchersBase
      end
    end
  end
end

matcher = Matchi::Matchers::Foo::Matcher.new

# It is expected to raise NotImplementedError
begin
  matcher.matches? { 42 } && raise
rescue NotImplementedError => e
  e
end
