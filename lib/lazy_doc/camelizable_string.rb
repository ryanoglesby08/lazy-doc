module LazyDoc
  class CamelizableString
    attr_reader :original

    def initialize(original)
      @original = original
    end

    def camelize
      original.gsub(/(_)(.)/) { $2.upcase }
    end

  end

end