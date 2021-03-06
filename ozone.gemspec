# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ozone/version'

Gem::Specification.new do |spec|
  spec.name          = "ozone"
  spec.version       = Ozone::VERSION
  spec.authors       = ["Hubert Huang"]
  spec.email         = ["hubert77@gmail.com"]

  spec.summary       = 'Convert time zones based on offset and daylight savings observance'
  spec.homepage      = "https://github.com/practicefusion/ozone"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  #end

  spec.add_dependency "activesupport", ">= 3"
  spec.add_dependency "tzinfo"

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
