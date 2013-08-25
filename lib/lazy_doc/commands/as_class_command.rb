module LazyDoc::Commands
  class AsClassCommand
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def execute(value)
      klass.nil? ? value : klass.new(value.to_json)
    end
  end
end