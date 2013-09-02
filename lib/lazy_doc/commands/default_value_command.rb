module LazyDoc::Commands
  class DefaultValueCommand
    attr_reader :default

    def initialize(default)
      @default = default
    end

    def execute(value)
      use_default?(value) ? default : value
    end

    private

    def use_default?(value)
      !default.nil? && (value.nil? || value.empty?)
    end
  end
end