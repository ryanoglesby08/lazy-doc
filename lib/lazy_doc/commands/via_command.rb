module LazyDoc::Commands
  class ViaCommand
    attr_reader :path

    def initialize(path)
      @path = [path].flatten
    end

    def execute(document)
      path.inject(document) do |final_value, attribute|
        unless final_value.has_key?(attribute.to_s)
          raise LazyDoc::AttributeNotFoundError.new("Unable to access #{attribute} via #{path.join(', ')}")
        end

        final_value[attribute.to_s]
      end
    end

  end

end
