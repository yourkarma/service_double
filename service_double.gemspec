# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'service_double/version'

Gem::Specification.new do |spec|
  spec.name          = "service_double"
  spec.version       = ServiceDouble::VERSION
  spec.authors       = ["iain"]
  spec.email         = ["iain@iain.nl"]
  spec.description   = %q{A tool for making fake versions of external (web) services.}
  spec.summary       = %q{A tool for making fake versions of external (web) services.}
  spec.homepage      = "https://github.com/yourkarma/service_double"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "sinatra"
  spec.add_dependency "verbose_hash_fetch"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "cucumber"
end
