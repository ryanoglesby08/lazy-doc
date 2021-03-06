module LazyDoc
  module DSL
    include ParseIfNecessary

    def self.included(base)
      base.extend ClassMethods
    end

    def lazily_embed(document)
      @embedded_doc_source = document
    end

    private

    def memoizer
      @memoizer ||= Memoizer.new
    end

    def embedded_doc
      @embedded_doc ||= parse_if_necessary(@embedded_doc_source)
    end


    module ClassMethods
      def access(*arguments)
        attributes, options = extract_from(arguments)

        if attributes.size == 1
          define_access_method_for(attributes[0], options)
        else
          define_access_methods_for(attributes)
        end
      end

      def define_access_method_for(attribute, options)
        optional_commands = Commands.create_commands_for options
        create_method(attribute, Commands::ViaCommand.new(options[:via] || attribute), optional_commands)
      end

      def define_access_methods_for(attributes)
        attributes.each do |attribute|
          create_method(attribute, Commands::ViaCommand.new(attribute))
        end

      end

      def create_method(attribute, via_command, optional_commands = [])
        define_method attribute do
          memoizer.memoize attribute do
            value = via_command.execute(embedded_doc)

            optional_commands.inject(value) do |final_value, command|
              final_value = command.execute(final_value)
              final_value
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

    end

  end

end
