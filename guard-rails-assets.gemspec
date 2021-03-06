# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'guard/rails-assets/version'

Gem::Specification.new do |s|
  s.name        = 'guard-rails-assets'
  s.version     = Guard::RailsAssetsVersion::VERSION
  s.authors     = ['Dmytrii Nagirniak']
  s.email       = ['dnagir@gmail.com']
  s.homepage    = 'http://github.com/guard/guard-rails-assets'
  s.summary     = 'Guard for compiling Rails assets'
  s.description = 'guard-rails-assets automatically generates JavaScript, CSS, Image files using Rails assets pipelie'

  s.licenses    = %w(MIT WTFPL)

  s.rubyforge_project = 'guard-rails-assets'

  s.add_dependency 'guard', '~> 2.6'
  s.add_dependency 'guard-compat', '~> 1.1'
  s.add_dependency 'rake'
  s.add_dependency 'rails', '>= 3.1.1'
  s.add_development_dependency 'rspec', '~> 3.1'
  s.add_development_dependency 'nenv', '~> 0.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
