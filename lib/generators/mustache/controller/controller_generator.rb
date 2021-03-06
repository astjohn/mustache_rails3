require 'generators/mustache'
require 'rails/generators/named_base'

class Mustache
  module Generators
    class ControllerGenerator < ::Rails::Generators::NamedBase
      extend TemplatePath

      argument :actions, :type => :array, :default => [], :banner => "action action"

      def create_view_files
        model_path                  = File.join(class_path, file_name)

        base_mustache_view_path     = File.join("app/views", model_path)
        empty_directory base_mustache_view_path

        base_mustache_template_path = File.join("app/assets/javascripts/templates", model_path)
        empty_directory base_mustache_template_path

        actions.each do |action|
          @action  = action
          mustache_template_path   = File.join(base_mustache_template_path,
                                                "#{action}.mustache")

          template "view.mustache.erb", mustache_template_path
        end
      end

      protected

      # Methods not to be executed go here

    end
  end
end
