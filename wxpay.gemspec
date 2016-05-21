# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wxpay/version'

Gem::Specification.new do |spec|
  spec.name          = "wxpay"
  spec.version       = Wxpay::VERSION
  spec.authors       = ["lifeixiong"]
  spec.email         = ["feixiongli@gmail.com"]

  spec.summary       = %q{An unofficial wechat pay gem.}
  spec.description   = %q{An unofficial wechat pay gem.}
  spec.homepage      = "https://github.com/feixionglee/wxpay"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_dependency             "nokogiri", ">= 1.6.6.2"
  spec.add_dependency             "faraday", "~> 0.9.1"
end
