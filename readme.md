# Mustache view template support for Rails 3

This generator and template handler for Mustache in Rails 3 is based on the
work of Paul Barry, Louis T., Martin Gamsjaeger, Les Hill, Adam Salter,
Chris Wanstrath, and Mike Smullin. Thank you for for allowing us all to
stand on your shoulders.


## Installation

Append to Gemfile:

```ruby
gem 'mustache'
gem 'mustache_rails3'
```


## Configuration

This is optional. You would only need this to change the default which is shown below.

```ruby
# ./config/initializer/mustache_rails.rb

Mustache::Rails::Config.template_base_path = Rails.root.join('app', 'assets', 'javascripts', 'templates')
```


## View Templates

```mustache
{{! ./app/assets/javascripts/templates/#{controller}/#{action}.mustache }}

Hello {{world}}!
```


## Layout Templates

These are optional.

```mustache
{{! ./app/assets/javascripts/templates/layouts/#{layout_name}.mustache }}

<h1>{{default_title}}</h1>
{{{yield}}}
```


## Plays nice wth:

* **hogan_assets.gem**: provides mustache asset pipeline support (aggregation, minification, global javascript object). https://github.com/leshill/hogan_assets

Sample configuration:

```ruby
# ./config/initializers/mustache.rb

Mustache::Railstache::Config.template_base_path = File.join(Rails.root, 'app', 'views')
HoganAssets::Config.template_extension = ['mustache', 'hamstache']
```

```javascript
// ./app/assets/javascripts/templates/index.js

//= require_tree ../../../views
```

```ruby
# ./config/application.rb

# Look for .mustache and .hamstache templates under ./app/views/*/*.mustache and ./app/views/*/*.hamstache
config.assets.paths << Rails.root.join('app', 'views')
```

```haml
-# ./views/#{controller}/#{action}.hamstache
{{#user}}
.user(id="user-{{id}}")
  %h1.name {{name}}
  {{#photo_url}}
  %img(src="{{photo_url}}")
  {{/photo_url}}
  {{^photo_url}}
  %img(src="http://placekitten.com/140/140")
  {{/photo_url}}
{{/user}}
```


## Greetz

* Thanks Chris for the encouragement http://ozmm.org/posts/haml___mustache.html

