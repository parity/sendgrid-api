# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sendgrid/api/version'

Gem::Specification.new do |spec|
  spec.name          = "parity-sendgrid-api"
  spec.version       = Sendgrid::API::VERSION
  spec.authors       = ["Jimish Jobanputra, Hardik Gondaliya"]
  spec.email         = ["jimish@desidime.com"]
  spec.description   = %q{A Ruby interface to the SendGrid API}
  spec.summary       = %q{A Ruby interface to the SendGrid API}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday', '~> 0.9.0'
  spec.add_dependency 'json', '~> 1.8.1'
end
