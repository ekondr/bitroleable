lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bitroleable/version'

Gem::Specification.new do |spec|
  spec.name          = 'bitroleable'
  spec.version       = Bitroleable::VERSION
  spec.authors       = ['Eugene Kondratiuk']
  spec.email         = ['ekondr@gmail.com']
  spec.summary       = "Store user's roles in an integer column of database"
  spec.description   = "Store user's roles in an integer column of database. Have ability to store multi-roles for users."
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rails'
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-rails'
end
