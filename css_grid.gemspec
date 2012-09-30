# -*- encoding: utf-8 -*-
require File.expand_path('../lib/css_grid/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Petrachi"]
  gem.email         = ["thomas.petrachi@vodeclic.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "css_grid"
  gem.require_paths = ["lib"]
  gem.version       = CssGrid::VERSION
  
  gem.add_dependency "railties", ">= 3.1.0"
  gem.add_dependency "hash_extend"
end
