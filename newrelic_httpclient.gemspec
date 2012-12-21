# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'newrelic_httpclient/version'

Gem::Specification.new do |gem|
  gem.name          = "newrelic-httpclient"
  gem.version       = NewrelicHttpclient::VERSION
  gem.authors       = ["Yuki Nishijima"]
  gem.email         = ["mail@yukinishijima.net"]
  gem.description   = %q{newrelic-httpclient allows transactions to show time spent inside httpclient requests}
  gem.summary       = %q{NewRelic instrumentation for HttpClient}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "newrelic_rpm"
  gem.add_development_dependency "httpclient"
end
