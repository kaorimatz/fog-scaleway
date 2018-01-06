lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fog/scaleway/version'

Gem::Specification.new do |spec|
  spec.name          = 'fog-scaleway'
  spec.version       = Fog::Scaleway::VERSION
  spec.authors       = ['Satoshi Matsumoto']
  spec.email         = ['kaorimatz@gmail.com']

  spec.summary       = 'Fog provider for Scaleway'
  spec.description   = 'Fog provider gem to support Scaleway.'
  spec.homepage      = 'https://github.com/kaorimatz/fog-scaleway'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'minitest'
  spec.add_development_dependency 'net-ssh'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'simplecov'

  spec.add_dependency 'fog-core', '~> 1.42'
  spec.add_dependency 'fog-json', '~> 1.0'
end
