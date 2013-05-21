# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'flickr-store/version'

Gem::Specification.new do |gem|
  gem.name          = "flickr-store"
  gem.version       = Flickr::Store::VERSION
  gem.authors       = ["Ryan LeFevre"]
  gem.email         = ["meltingice8917@gmail.com"]
  gem.description   = %q{Store arbitrary data with your 1TB Flickr cloud drive.}
  gem.summary       = %q{Store arbitrary data with your 1TB Flickr cloud drive by encoding any file as a PNG. This is mostly a proof of concept right now. Don't do anything beyond tinkering with it yet.}
  gem.homepage      = "http://github.com/meltingice/flickr-store"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "png-encode"
  gem.add_dependency "flickraw"
end
