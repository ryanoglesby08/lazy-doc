module LazyDoc
  class Collection
    extend ParseIfNecessary

    def self.build(document, element_class)
      as_class_command = Commands::AsClassCommand.new(element_class)
      collection = as_class_command.execute(parse_if_necessary(document))

      [collection].flatten
    end
  end
end