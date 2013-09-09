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

    def memoizer
      @_memoizer ||= Memoizer.new
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
          via_command           = Commands::ViaCommand.new(options[:via])
          default_value_command = Commands::DefaultValueCommand.new(options[:default])
          as_class_command      = Commands::AsClassCommand.new(options[:as])
          finally_command       = Commands::FinallyCommand.new(options[:finally])

          define_method attribute do
            memoizer.memoize attribute do
              value = via_command.execute(embedded_doc)

              value = default_value_command.execute(value)
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
