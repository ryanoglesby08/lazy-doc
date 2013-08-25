module LazyDoc::Commands
  class FinallyCommand
    attr_reader :transformation

    NO_OP_TRANSFORMATION = lambda { |value| value }

    def initialize(transformation)
      @transformation = transformation || NO_OP_TRANSFORMATION
    end

    def execute(value)
      transformation.call(value)
    end
  end
end