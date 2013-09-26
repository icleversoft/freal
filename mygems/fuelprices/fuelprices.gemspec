# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fuelprices/version'

Gem::Specification.new do |spec|
  spec.name          = "fuelprices"
  spec.version       = Fuelprices::VERSION
  spec.authors       = ["icleversoft"]
  spec.email         = ["iphone@icleversoft.com"]
  spec.description   = %q{Parses for a given code list and fuel type the fuelprices.gr and gets specific data for each station.}
  spec.summary       = %q{TODO: Parses fuelprices.gr}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "nokogiri"
  spec.add_development_dependency "iconv"
  spec.add_development_dependency "open-uri"
  spec.add_development_dependency "rake"
end
