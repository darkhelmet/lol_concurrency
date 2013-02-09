# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lol_concurrency/version'

Gem::Specification.new do |gem|
  gem.name          = 'lol_concurrency'
  gem.version       = LolConcurrency::VERSION
  gem.authors       = ['Daniel Huckstep']
  gem.email         = ['darkhelmet@darkhelmetlive.com']
  gem.description   = %q{A super simple actor & concurrency library.}
  gem.summary       = %q{A super simple actor & concurrency library.}
  gem.homepage      = 'https://github.com/darkhelmet/lol_concurrency'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_development_dependency('rspec', '~> 2.12')
end
