require 'json'

module LazyDoc
  module DSL
    def self.included(base)
      base.extend ClassMethods
    end

    def init(json)
      @json = JSON.parse(json)
    end

    private

    def cache(property, &block)
      property_variable_name = "@_lazy_doc_#{property}"
      unless instance_variable_defined?(property_variable_name)
        instance_variable_set(property_variable_name, block.call)
      end

      instance_variable_get(property_variable_name)
    end


    module ClassMethods
      def find(attribute, options = {})
        json_property = options[:by] || attribute

        define_method attribute do
          cache attribute do
            @json[json_property.to_s]
          end

        end

      end

    end

  end

end