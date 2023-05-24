# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'capistrano/kitchen_deploy/version'

Gem::Specification.new do |spec|
  spec.name = 'capistrano-kitchen_deploy'
  spec.version = Capistrano::KitchenDeploy::VERSION
  spec.authors = ['Eearslya Sleiarion']
  spec.email = ['eearslya@gmail.com']
  spec.summary = 'Set of tasks made to complement a Chef server deployment'
  spec.homepage = 'https://github.com/Eearslya/capistrano-kitchen_deploy'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']

  spec.add_dependency 'capistrano', '~> 3.17'
  spec.add_dependency 'capistrano3-puma', '~> 5.2'
  spec.add_dependency 'capistrano-sidekiq', '~> 2.3'

  spec.add_development_dependency 'bundler', '~> 2.4'
end
