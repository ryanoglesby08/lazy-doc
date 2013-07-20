require 'json'

module LazyDoc
  module DSL
    def self.included(base)
      base.extend ClassMethods
    end

    def lazily_embed(json)
      @_lazy_doc_document = JSON.parse(json)
    end

    private

    def memoize(attribute)
      attribute_variable_name = "@_lazy_doc_#{attribute}"
      unless instance_variable_defined?(attribute_variable_name)
        instance_variable_set(attribute_variable_name, yield)
      end

      instance_variable_get(attribute_variable_name)
    end

    def extract_json_attribute_from(json_path)
      json_path.inject(@_lazy_doc_document) do |final_value, attribute|
        final_value[attribute.to_s]
      end
    end


    module ClassMethods
      def access(attribute, options = {})
        json_path = options[:via] || attribute
        json_path = [json_path].flatten

        define_method attribute do
          memoize attribute do
            extract_json_attribute_from json_path
          end

        end

      end

    end

  end

end