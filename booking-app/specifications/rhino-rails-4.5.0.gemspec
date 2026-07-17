# -*- encoding: utf-8 -*-
# stub: rhino-rails 4.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rhino-rails".freeze
  s.version = "4.5.0".freeze

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Bruno Cipolla".freeze]
  s.date = "1980-01-02"
  s.description = "Rhino automatically generates complete REST APIs from ActiveRecord models with filtering, sorting, search, pagination, role-based authorization, multi-tenancy, audit trail, and more.".freeze
  s.email = ["bruno@codalio.com".freeze]
  s.homepage = "https://github.com/rhino-project/rhino-rails".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.3.0".freeze)
  s.rubygems_version = "3.6.9".freeze
  s.summary = "Automatic REST API generation for Rails models".freeze

  s.installed_by_version = "3.6.9".freeze

  s.specification_version = 4

  s.add_runtime_dependency(%q<rails>.freeze, [">= 8.0".freeze])
  s.add_runtime_dependency(%q<pundit>.freeze, ["~> 2.3".freeze])
  s.add_runtime_dependency(%q<pagy>.freeze, ["~> 9.0".freeze])
  s.add_runtime_dependency(%q<discard>.freeze, ["~> 1.3".freeze])
  s.add_runtime_dependency(%q<bcrypt>.freeze, ["~> 3.1".freeze])
  s.add_runtime_dependency(%q<tty-prompt>.freeze, ["~> 0.23".freeze])
  s.add_runtime_dependency(%q<request_store>.freeze, ["~> 1.5".freeze])
  s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 7.0".freeze])
  s.add_development_dependency(%q<factory_bot_rails>.freeze, ["~> 6.4".freeze])
  s.add_development_dependency(%q<sqlite3>.freeze, ["~> 2.0".freeze])
  s.add_development_dependency(%q<combustion>.freeze, ["~> 1.4".freeze])
  s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.22".freeze])
end
