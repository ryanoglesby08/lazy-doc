module LazyDoc::Commands
  class ExtractCommand

    attr_reader :attribute_to_extract

    def initialize(attribute_to_extract)
      @attribute_to_extract = attribute_to_extract
    end

    def execute(value)
      attribute_to_extract.nil? ? value : value.map { |element| element[attribute_to_extract.to_s] }
    end
  end

end
