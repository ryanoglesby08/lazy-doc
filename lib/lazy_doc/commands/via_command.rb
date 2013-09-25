module LazyDoc::Commands
  class ViaCommand
    attr_reader :path

    def initialize(path)
      @path = [path].flatten
    end

    def execute(document)
      path.inject(document) do |sub_document, attribute|
        attribute_identifier = determine_attribute_identifier(attribute, sub_document)

        sub_document[attribute_identifier]
      end
    end

    private

    def determine_attribute_identifier(attribute, sub_document)
      camelizable_attribute = LazyDoc::CamelizableString.new(attribute.to_s)

      if sub_document.has_key?(camelizable_attribute.original)
         camelizable_attribute.original
      elsif sub_document.has_key?(camelizable_attribute.camelize)
         camelizable_attribute.camelize
      else
        raise LazyDoc::AttributeNotFoundError.new("Unable to access #{attribute} via #{path.join(', ')}")
      end

    end

  end

end
