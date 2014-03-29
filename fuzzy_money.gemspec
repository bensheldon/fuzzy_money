# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fuzzy_money/version'

Gem::Specification.new do |spec|
  spec.name          = "fuzzy_money"
  spec.version       = FuzzyMoney::VERSION
  spec.authors       = ["Ben Sheldon"]
  spec.email         = ["bensheldon@gmail.com"]
  spec.summary       = %q{Make accurate-enough conversions and comparisons between price strings.}
  spec.description   = %q{Make accurate-enough conversions and comparisons between price strings. For when you're collecting inconsistently structured pricing information (for example, via scraping) and you don't need the rigidness of [RubyMoney](https://github.com/RubyMoney/money).
}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  # spec.add_development_dependency "simplecov"
  # spec.add_development_dependency "coveralls"
end
