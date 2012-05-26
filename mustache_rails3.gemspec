Gem::Specification.new do |gem|
  gem.authors       = ["Michael Harrison", "Paul Barry", "Louis T.", "Martin Gamsjaeger"]
  gem.email         = ["mh@michaelharrison.ws"]
  gem.description   = %q{Mustache_rails3 is intended to add Rails 3 support to the existing mustache templating system for Ruby. It provides a template handler for Rails 3 and generators. I strive to make the gem work with the latest beta or release candidate of Rails 3. The source code is maintained at http://github.com/goodmike/mustache_rails3, and I welcome comments and forks. I thank Jens Bissinger for his Rails 3 RC 1 patch.}
  gem.summary       = %q{Mustache_rails3 provides a template handler and generators for Rails 3.}
  gem.homepage      = "http://github.com/Factlink/mustache_rails3"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "mustache_rails3"
  gem.require_paths = ["lib"]
  gem.version       = "0.1.2.4"

  gem.add_development_dependency "fakefs"
  gem.add_runtime_dependency "mustache", ">= 0.99.4"
end
