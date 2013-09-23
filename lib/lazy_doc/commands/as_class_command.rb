module LazyDoc::Commands
  class AsClassCommand
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def execute(value)
      if klass.nil?
        value
      else
        if value.is_a? Array
          value.map { |element| klass.new(element.to_json) }
        else
          klass.new(value.to_json)
        end
      end

    end
  end
end