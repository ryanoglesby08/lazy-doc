require 'json'

module LazyDoc
  module ParseIfNecessary
    def parse_if_necessary(document)
      already_parsed?(document) ? document : JSON.parse(document)
    end

    private

    def already_parsed?(document)
      document.is_a?(Hash) || document.is_a?(Array)
    end
  end
end