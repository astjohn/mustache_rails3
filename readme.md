# Mustache view template support for Rails 3

This generator and template handler for Mustache in Rails 3 is based on the
work of Paul Barry, Louis T., and Martin Gamsjaeger. I am indebted to them
for allowing me to stand on their shoulders.

This is also available as a [rubygem](http://rubygems.org/gems/mustache_rails3).

THIS CODE IS ALPHA. I have asked for comments on [the mustache project Rails
Support issue ticket](http://github.com/defunkt/mustache/issues/#issue/3/comment/294928).
Please leave feedback there, and thanks.


## Installation

Append to Gemfile:

<pre><code>
gem 'mustache'
gem 'mustache_rails3'
</code></pre>


## Configuration

<pre><code>#config/initializer/mustache_rails.rb
Mustache::Rails::Config.template_base_path = Rails.root.join('app', 'assets', 'javascripts', 'templates')
</code></pre>


### View Templates

<pre><code>#app/assets/javascripts/templates/#{controller}/#{action}.mustache

Hello {{world}}!
</code></pre>


## Layout Templates

<pre><code>#app/assets/javascripts/templates/layouts/#{layout_name}.mustache

&lt;h1>{{default_title}}&lt;/h1>
{{{yield}}}
</code></pre>


## Plays nice wth:

* hogan_assets.gem: provides mustache asset pipeline support. https://github.com/leshill/hogan_assets


## TODO:

* Add support for easy conversion of Rails::Mustache objects to JSON representations
