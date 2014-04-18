# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'superbolt/future/version'

Gem::Specification.new do |spec|
  spec.name          = "superbolt-future"
  spec.version       = Superbolt::Future::VERSION
  spec.authors       = ["Deepti Anand", "Kane Baccigalupi", "SocialCoder's at SocialChorus"]
  spec.email         = ["developers@socialchorus.com"]
  spec.description   = %q{Perform superbolt tasks at a later time; timed job queues for the cloud}
  spec.summary       = %q{Perform superbolt tasks at a later time; timed job queues for the cloud}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'superbolt'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
