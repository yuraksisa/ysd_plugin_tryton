# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ysd_plugin_tryton/version'

Gem::Specification.new do |spec|
  spec.name          = "ysd_plugin_tryton"
  spec.version       = YsdPluginTryton::VERSION
  spec.authors       = ["Yurak Sisa"]
  spec.email         = ["yurak.sisa.dream@gmail.com"]
  spec.summary       = %q{Tryton integration}
  spec.description   = %q{Tryton integration}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "dm-sqlite-adapter"   

  spec.add_dependency "faraday"
  spec.add_dependency "dm-observer"

  spec.add_dependency "ysd_md_payment"
  spec.add_dependency "ysd_md_booking"
  spec.add_dependency "ysd_md_integration"
  spec.add_dependency "ysd_md_order"
  spec.add_dependency "ysd_md_translation"

end
