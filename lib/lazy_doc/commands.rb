module LazyDoc
  module Commands
  end
end

require 'lazy_doc/commands/as_class_command'
require 'lazy_doc/commands/default_value_command'
require 'lazy_doc/commands/extract_command'
require 'lazy_doc/commands/finally_command'
require 'lazy_doc/commands/via_command'

module LazyDoc::Commands
  OPTIONAL_COMMAND_CLASSES = {
    default: DefaultValueCommand,
    as: AsClassCommand,
    extract: ExtractCommand,
    finally: FinallyCommand
  }

  def self.create_commands_for(options)
    options.map do |key, initialization_value|
      if OPTIONAL_COMMAND_CLASSES.has_key?(key)
        OPTIONAL_COMMAND_CLASSES[key].new(initialization_value)
      end
    end.compact

  end
end
