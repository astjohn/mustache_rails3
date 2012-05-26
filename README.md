# Do you ...
* **Want to use .Mustache view templates in Rails 3?**
* **Want all your Mustache templates to be compatible with the Rails Asset Pipeline?**
* **Want to get crazy with some HAML Mustache a.k.a. .Hamstache?**

Well, you've come to the right gem...

## Mustache Rails 3

These Mustaches currently come in two distinct flavors: **Regular**, and **Hamstache**.

## The Regular Mustache

## Installation

Append to Gemfile:

```ruby
gem 'mustache'
gem 'mustache_rails3', git: 'git://github.com/mikesmullin/mustache_rails3.git'
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
{{> hello_again }}
```


## Including Partial View Templates

Notice the last line of the previous template. That will include the following
partial `.mustache` template:

```mustache
{{! ./app/assets/javascripts/templates/#{controller}/_hello_again.mustache }}
{{! or ./app/assets/javascripts/templates/shared/_hello_again.mustache }}

Hello again, {{world}}!
{{>
```


## Layout Templates

These are optional.

```mustache
{{! ./app/assets/javascripts/templates/layouts/#{layout_name}.mustache }}

<h1>{{default_title}}</h1>
{{{yield}}}
```

## Context ... it depends.

Or "how NOT to use Rails helpers". Remember, Mustache is the logic-less template format.
Rails Asset Pipeline includes no context when compiling `.js` or any other asset. That's one 
reason why SASS/SCSS has to provide their own url helper ruby functions for referencing 
image file paths. There are NO `link_to` or `user_login_path` ActionView::Helpers
available in the scope of your asset files.

You'll generally need to understand and remain aware of this when writing your templates. Look
carefully at the example view templates in this `README.md` for a guide.

Most context will be passed either via Mustache `{{variables}}` or via content blocks.


## The Hamstache

Because everything tastes better with bacon--err, HAML... all up in your 'stache!

## Installation

Append to Gemfile:

```ruby
gem 'mustache'
gem 'mustache_rails3', git: 'git://github.com/mikesmullin/mustache_rails3.git'
group :assets do
  gem 'hogan_assets', git: 'git://github.com/mikesmullin/hogan_assets.git'
end
```

Notice hogan_assets.gem provides, in addition to mustache asset pipeline support,
template aggregation, minification with Google closure, and a handy global javascript 
object to reference all your beautiful 'staches from anywhere on your site.


## Configuration

This initializer is strongly recommended, but not default, yet. Consider carefully...
it tells both Rails and Hogan to look to a single `./app/views/*/*.hamstache` template for
both front-end and back-end rendering. NO MORE DOUBLE-TREES! I expect this is the way to
the future.

```ruby
# ./config/initializers/mustache.rb

Mustache::Railstache::Config.template_base_path = File.join(Rails.root, 'app', 'views')
Mustache::Railstache::Config.shared_path = File.join(Rails.root, 'app', 'views', 'shared')
```

This tells Rails Asset Pipeline to look in the non-standard `./app/views/*` tree recursively
for any `.mustache` or `.hamstache` templates to include.

```javascript
// ./app/assets/javascripts/templates/index.js

//= require_tree ../../../views
```

This allows Rails Asset Pipeline to look outside the standard `./app/assets/*` directory. A
security feature by default, I presume.

```ruby
# ./config/application.rb

# Look for .mustache and .hamstache templates under ./app/views/*/*.mustache and ./app/views/*/*.hamstache
config.assets.paths << Rails.root.join('app', 'views')
```

## View Templates

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
  .actions
    %ul.float-left
      %li
        %a(href='#' class='button button-gray') Ping User
      %li
        %a(href='{{new_contact_path}}' class='button button-red')
          %span.icon-plus
          Add New Contact
{{/user}}
```


## Greetz

This generator and template handler is based on the work of Paul Barry, Louis T., Martin Gamsjaeger, 
Michael Harrison, Les Hill, Adam Salter, Chris Wanstrath, and Mike Smullin. Thank you for for 
allowing us all to stand a little taller on your shoulders.


## See also

* HAML and Mustache are friends, not enemies. http://ozmm.org/posts/haml___mustache.html
* Mustache manual and demo. http://mustache.github.com/
* Hoagan.js reference. http://twitter.github.com/hogan.js/
* hogan_assets.gem by Les Hill https://github.com/leshill/hogan_assets


## For VIM users

To add syntax highlighting support for .Hamstache, append to your `~/.vimrc`:

```vimrc
au Bufread,BufNewFile *.hamstache set filetype=haml
```

## Emacs users

Append somewhere. e.g., `~/.emacs.d/init.el`:

```lisp
(add-to-list 'auto-mode-alist '("\\.hamstache$" . haml-mode))
```
