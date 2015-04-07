lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rendaku/version'

Gem::Specification.new do |s|
  s.name          = 'rendaku'
  s.version       = Rendaku::VERSION
  s.authors       = ['Travis Anderson']
  s.email         = 'dev-anderson@augustdecember.com'
  s.description   = 'Tool for creating book-folding template instructions. Inspired by https://github.com/Moini/BookArtGenerator'
  s.summary       = 'Tool for creating book-folding template instructions.'
  s.homepage      = 'https://github.com/travis-anderson/rendaku'
  s.license       = 'MIT'

  s.files         = `git ls-files`.split($/)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.required_ruby_version = ">= 1.9.3"
  s.add_dependency 'rmagick', '~> 2.13'
end
