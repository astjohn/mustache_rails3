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


## Controller Actions

```ruby
# GET /contacts
# GET /contacts.json
def index
  @contacts = Contacts.all

  respond_to do |format|
    format.html # index.hamstache
    format.json { render json: @contacts } # for responding to AJAX; provides data only and in json format
  end
end

# GET /contacts/1
# GET /contacts/1.json
def show
  @contact = Contacts.find(params[:id])
  
  respond_to do |format|
    format.html # show.hamstache or edit.hamstache; same thing
    format.json { render json: @contact } # for responding to AJAX; provides data only and in json format
  end
end
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
{{! ./app/assets/javascripts/templates/#{controller}/hello_again.mustache }}
{{! or ./app/assets/javascripts/templates/shared/hello_again.mustache }}

Hello again, {{world}}!
```


## Layout Templates

These are optional.

```mustache
{{! ./app/assets/javascripts/templates/layouts/#{layout_name}.mustache }}

<h1>{{default_title}}</h1>
{{{yield}}}
```

## Context ... it depends.

The hardest part of using this gem will be getting into the habit of passing context via json, 
and moving all presentation logic to the front-end, especially to support the otherwise logicless 
mustache templates.

To pass context, if all you want to do is use Mustache to render templates Ruby-side, then using 
Rails helpers is fine. But if you [also or alternatively] need to render on the front-end, then
you must remember Rails Asset Pipeline includes no context when compiling `.js` or any other 
asset. That's one reason SASS/SCSS has custom url helper functions for image paths. There are 
NO `link_to` or `user_login_path` ActionView::Helpers available in the scope of your asset files, 
so if you want them you'll have to port the Ruby/Rails implementations of those helpers to 
equivalent front-end JavaScript/CoffeeScript behaviors.

Most contextual data will need to be passed from controller action as `respond_to` `.json` to 
Mustache `{{variables}}` which often go good inline with your markup hierarchy as HTML5 data 
attributes. Sometimes you will pass raw data and only implement a `.js` helper to format it on
page load. Other times you will implement a `.rb` and a `.js` version of the same helper so
that it can be rendered the same by server-side or client-side. I personally prefer the
former approach. My philosophy is to keep all presentation logic out of your 'staches AND 
your controller actions;it belongs in the front-end. 

Look carefully at the view templates shown in this `README.md` for specific examples.

If you go with my philosophy, then a View-Controller (no Model) front-end framework like
Joosy.ws probably works best, since the data is passed to match the template hierarchy, 
not like an api which serves resources mapped to database tables. You'll probably find
libraries like Sugar.js a useful replacement for default Rails helpers, as well.


## The Hamstache

Because everything tastes better with bacon--err, HAML... all up in your 'stache! Chunky bacon!!

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
