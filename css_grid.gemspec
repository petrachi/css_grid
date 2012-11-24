# -*- encoding: utf-8 -*-
require File.expand_path('../lib/css_grid/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Petrachi"]
  gem.email         = ["thomas.petrachi@vodeclic.com"]
  gem.description   = %q{Provide CSS grid stylesheet and CSS grid helpers}
  gem.summary       = %q{grid.css.scss and GridHelper module}
  gem.homepage      = "https://github.com/petrachi/css_grid"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "css_grid"
  gem.require_paths = ["lib"]
  gem.version       = CssGrid::VERSION
end
