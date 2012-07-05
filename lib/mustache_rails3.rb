class Mustache
  # Remember to use {{{yield}}} (3 mustaches) to skip escaping HTML
  # Using {{{tag}}} will skip escaping HTML so if your mustache methods return
  # HTML, be sure to interpolate them using 3 mustaches.

  # Override Mustache's default HTML escaper to only escape strings that
  # aren't marked `html_safe?`
  def escapeHTML(str)
    str.html_safe? ? str : CGI.escapeHTML(str)
  end


  class Railstache < Mustache
    attr_accessor :view

    def method_missing(method, *args, &block)
      view.send(method, *args, &block)
    end

    def respond_to?(method, include_private=false)
      super(method, include_private) || view.respond_to?(method, include_private)
    end

    # function to return a view, routing around standard rails viewing. Useful to get a view object
    # in a controller, and subsequently render to json and return this to the client, which then renders
    def self.for(options={})
      stache = new(false)
      stache.view = options[:view]
      options.delete(:view)

      options.each do |key, value|
        stache[key] = value
      end

      stache.init
      return stache
    end

    def initialize(run=true)
      init if run
    end

    #override this function to do the initialize
    def init
    end

    class <<self; attr_reader :fields_for_hash; end
    def self.expose_to_hash(*fields)
      @fields_for_hash ||= Array.new
      @fields_for_hash |= fields
    end

    def to_hash
      rv = {}
      (methods - Mustache::Railstache.instance_methods).each do |m|
        rv[m] = send(m)
      end
      if self.class.fields_for_hash
        self.class.fields_for_hash.each do |m|
          rv[m] = self[m]
        end
      end
      rv
    end

    # Redefine where Mustache::Railstache templates locate their partials:
    #
    # (1) in the same directory as the current template file.
    # (2) in the shared templates path (can be configured via Config.shared_path=(value))
    #
    def partial(name)
      name = name.to_s

      if name.index '/'
        dir, name = name.split(/\//)

        template_dir = "#{Config.template_base_path}/#{dir}"
      else
        template_dir = Pathname.new(self.template_file).dirname
      end

      partial_name = "#{name}#{Pathname.new(self.template_file).extname}"
      partial_path = File.expand_path("#{template_dir}/#{partial_name}")

      unless dir or File.file?(partial_path)
        partial_path = "#{Config.shared_path}/#{partial_name}"
      end

      File.read(partial_path)
    end

    # You can change these defaults in, say, a Rails initializer or
    # environment.rb, e.g.:
    #
    # Mustache::Railstache::Config.template_base_path = Rails.root.join('app', 'assets', 'javascripts', 'templates')
    module Config
      def self.template_base_path
        @template_base_path ||= ::Rails.root.join('app', 'assets', 'javascripts', 'templates')
      end

      def self.template_base_path=(value)
        @template_base_path = value
      end

      def self.template_extension
        @template_extension ||= 'mustache'
      end

      def self.template_extension=(value)
        @template_extension = value
      end

      def self.shared_path
        @shared_path ||= ::Rails.root.join('app', 'assets', 'javascripts', 'templates', 'shared')
      end

      def self.shared_path=(value)
        @shared_path = value
      end
    end

    class MustacheTemplateHandler
      class_attribute :default_format
      self.default_format = :mustache

      def logic(template)
        class_name = mustache_class_from_template(template)
        <<-MUSTACHE
          mustache = ::#{class_name}.new
          mustache.view = self
          mustache[:yield] = content_for(:layout)
          mustache.context.update(local_assigns)
          variables = controller.instance_variable_names
          variables -= %w[@template]

          if controller.respond_to?(:protected_instance_variables)
            variables -= controller.protected_instance_variables
          end

          variables.each do |name|
            mustache.instance_variable_set(name, controller.instance_variable_get(name))
          end

          # Declaring an +attr_reader+ for each instance variable in the
          # Mustache::Railstache subclass makes them available to your templates.
          mustache.class.class_eval do
            attr_reader *variables.map { |name| name.sub(/^@/, '').to_sym }
          end

          # provide reverse link to reference within view
          # useful in lambda functions like
          # lambda {|text| @mustache.render(text).downcase }
          self.instance_variable_set('@mustache', mustache)
        MUSTACHE
      end

      # @return [String] its evaled in the context of the action view
      # hence the hack below
      #
      # @param [ActionView::Template]
      def call(template)
        source = template.source.empty? ? File.read(template.identifier) : template.source

        <<-MUSTACHE
          #{logic(template)}

          mustache.template_file = #{File.join(Rails.root, Pathname.new(template.inspect)).inspect}
          mustache.template_path = #{File.join(Rails.root, Pathname.new(template.inspect).dirname.to_s).inspect}
          mustache.template_extension = #{Pathname.new(template.inspect).extname.inspect}
          source = #{source.inspect}
          options = #{options.inspect}

          mustache.render source
        MUSTACHE
      end

      # In Rails 3.1+, #call takes the place of #compile
      def self.call(template)
        new.call(template)
      end
      private
      def mustache_class_from_template(template)
        const_name = ActiveSupport::Inflector.camelize(template.virtual_path.to_s)
        defined?(const_name) ? const_name.constantize : Mustache::Railstache
      end
    end


    class HamstacheTemplateHandler < MustacheTemplateHandler
      def call(template)
        options = Haml::Template.options.dup if Haml::Template.options
        source = template.source.empty? ? File.read(template.identifier) : template.source

        <<-MUSTACHE
          #{logic(template)}

          mustache.template_file = #{File.join(Rails.root, Pathname.new(template.inspect)).inspect}
          mustache.template_path = #{File.join(Rails.root, Pathname.new(template.inspect).dirname.to_s).inspect}
          mustache.template_extension = #{Pathname.new(template.inspect).extname.inspect}
          source = #{source.inspect}
          options = #{options.inspect}

          mustache.render(Haml::Engine.new(source, options).render(self)) # haml then mustache makes most sense
        MUSTACHE
      end
      private
      def mustache_class_from_template(template)
        const_name = ActiveSupport::Inflector.camelize(template.virtual_path.to_s)
        defined?(const_name) ? const_name.constantize : Mustache::Hamstache
      end
    end
  end
  class Hamstache < Railstache
    # Run Haml engine on partial.
    #
    def partial(name)
      file = super(name)
      options = Haml::Template.options.dup if Haml::Template.options
      options ||= {}
      Haml::Engine.new(file, options).render(self)
    end
  end
end

::ActionView::Template.register_template_handler(:mustache, Mustache::Railstache::MustacheTemplateHandler)
#::ActionView::Template.register_template_handler(:rb, Mustache::Railstache::HamstacheTemplateHandler)
['haml.mustache', :hamstache].each do |ext|
  ::ActionView::Template.register_template_handler(ext.to_sym, Mustache::Railstache::HamstacheTemplateHandler)
end
