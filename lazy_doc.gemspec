# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lazy_doc/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ryan Oglesby"]
  gem.email         = ["ryan.oglesby08@gmail.com"]
  gem.description   = %q{LazyDoc provides a declarative DSL for extracting deeply nested values from a JSON document}
  gem.summary       = %q{An implementation of the Embedded Document pattern for POROs}
  gem.homepage      = "https://github.com/ryanoglesby08/lazy-doc"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lazy_doc"
  gem.require_paths = ["lib"]
  gem.version       = LazyDoc::VERSION

  gem.license       = 'MIT'

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry-debugger"
end
