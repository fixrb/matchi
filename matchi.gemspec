# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                   = "matchi"
  spec.version                = File.read(File.join(__dir__, "VERSION.semver")).chomp
  spec.author                 = "Cyril Kato"
  spec.email                  = "contact@cyril.email"
  spec.summary                = "Framework-agnostic matchers for secure Ruby testing"

  spec.description = <<~DESC
    Matchi provides small, explicit expectation matchers for any Ruby testing framework. The expected value always controls the comparison, so the object under test cannot forge a match.
  DESC

  spec.homepage               = "https://fixrb.dev/gems/matchi/"
  spec.license                = "MIT"
  spec.files                  = Dir["LICENSE.md", "README.md", "lib/**/*.rb"]
  spec.required_ruby_version  = ">= 3.3.0"

  spec.metadata["bug_tracker_uri"]       = "https://github.com/fixrb/matchi/issues"
  spec.metadata["documentation_uri"]     = "https://rubydoc.info/gems/matchi"
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["source_code_uri"]       = "https://github.com/fixrb/matchi"
end
