# Be sure to install mustache gem and include mustache gem in project Gemfile.
require 'mustache_rails3'

# Generator
Rails.application.config.generators.template_engine :mustache

# Asset pipeline
Rails.application.assets.register_mime_type 'text/html', '.mustache'
Rails.application.assets.register_engine '.mustache', Tilt::MustacheTemplate
