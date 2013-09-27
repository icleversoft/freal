# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "greek_tokenizer"
  gem.version       = "0.0.1"
  gem.authors       = ["icleversoft"]
  gem.email         = ["iphone@icleversoft.com"]
  gem.description   = %q{Converts greek characters to lowercase according a given character map}
  gem.summary       = %q{Greek Tokenizer}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
