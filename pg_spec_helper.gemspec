# frozen_string_literal: true

require_relative "lib/pg_spec_helper/version"

Gem::Specification.new do |spec|
  spec.name = "pg_spec_helper"
  spec.version = PGSpecHelper::VERSION
  spec.authors = ["Craig Ulliott"]
  spec.email = ["craigulliott@gmail.com"]

  spec.summary = "Helper class for working with PostgreSQL in a testing environment"
  spec.description = "Helper class for setting up and easily tearing down PostgreSQL database objects within a testing environment"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["source_code_uri"] = "https://github.com/craigulliott/pg_spec_helper/"
  spec.metadata["changelog_uri"] = "https://github.com/craigulliott/pg_spec_helper/blob/main/CHANGELOG.md"

  spec.files = ["README.md", "LICENSE.txt", "CHANGELOG.md", "CODE_OF_CONDUCT.md"] + Dir["lib/**/*"]

  spec.require_paths = ["lib"]

  spec.add_dependency "pg", "~> 1.5"

  spec.add_development_dependency "yaml", "~> 0.2"
end
