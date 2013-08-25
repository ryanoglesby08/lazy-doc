require 'json'

module LazyDoc
  module DSL
    def self.included(base)
      base.extend ClassMethods
    end

    def lazily_embed(json)
      @_embedded_doc_source = json
    end

    private

    def memoize(attribute)
      attribute_variable_name = "@_lazy_doc_#{attribute}"
      unless instance_variable_defined?(attribute_variable_name)
        instance_variable_set(attribute_variable_name, yield)
      end

      instance_variable_get(attribute_variable_name)
    end

    def extract_attribute_from(json_path)
      json_path.inject(embedded_doc) do |final_value, attribute|
        final_value[attribute.to_s] || (raise AttributeNotFoundError, "Unable to access #{attribute} via #{json_path.join(', ')}")
      end
    end

    def embedded_doc
      @_embedded_doc ||= JSON.parse(@_embedded_doc_source)
    end


    module ClassMethods
      def access(*arguments)
        attributes, options = extract_from(arguments)
        attribute_options = build_attribute_options(attributes, options)
        define_access_methods_for(attribute_options)
      end

      def define_access_methods_for(attribute_options)
        attribute_options.each do |attribute, options|
          json_path = [options[:via]].flatten

          as_class_command = Commands::AsClassCommand.new(options[:as])
          finally_command = Commands::FinallyCommand.new(options[:finally])

          define_method attribute do
            memoize attribute do
              value = extract_attribute_from(json_path)
              value = as_class_command.execute(value)
              finally_command.execute(value)
            end

          end

        end

      end

      def extract_from(arguments)
        arguments << {} unless arguments.last.is_a? Hash

        options = arguments.pop
        attributes = [arguments].flatten

        verify_arguments(attributes, options)

        [attributes, options]
      end

      def verify_arguments(attributes, options)
        if attributes.size > 1 && !options.empty?
          raise ArgumentError, 'Options provided for multiple attributes'
        end
      end

      def build_attribute_options(attributes, options)
        attributes.inject({}) do |attribute_options, attribute|
          attribute_options[attribute] = default_options(attribute).merge(options)
          attribute_options
        end
      end

      def default_options(attribute)
        {
          via: attribute
        }
      end

    end

  end
end
