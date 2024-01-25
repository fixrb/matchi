# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name                   = "matchi"
  spec.version                = File.read("VERSION.semver").chomp
  spec.author                 = "Cyril Kato"
  spec.email                  = "contact@cyril.email"
  spec.summary                = "Collection of expectation matchers for Rubyists 🤹"
  spec.description            = spec.summary
  spec.homepage               = "https://github.com/fixrb/matchi"
  spec.license                = "MIT"
  spec.files                  = Dir["LICENSE.md", "README.md", "lib/**/*"]
  spec.required_ruby_version  = ">= 3.2.0"

  spec.metadata["rubygems_mfa_required"] = "true"
end
