require_relative '../../spec_helper'

module LazyDoc
  describe Commands do
    describe '#create_commands_for' do
      class FooCommand
        def initialize(_) end
      end
      class BarCommand
        def initialize(_) end
      end

      before(:all) do
        @optional_command_classes = Commands::OPTIONAL_COMMAND_CLASSES.dup
        Commands::OPTIONAL_COMMAND_CLASSES = {foo: FooCommand, bar: BarCommand}
      end

      after(:all) do
        Commands::OPTIONAL_COMMAND_CLASSES = @optional_command_classes
      end

      let(:initialization_value) { 'initialization value' }

      it 'creates a command object for the specified option' do
        options = {foo: initialization_value}
        commands = Commands.create_commands_for(options)

        expect(commands[0]).to be_a FooCommand
      end

      it 'creates a command object for multiple options' do
        options = {foo: initialization_value, bar: initialization_value}
        commands = Commands.create_commands_for(options)

        expect(commands[0]).to be_a FooCommand
        expect(commands[1]).to be_a BarCommand
      end

      it 'ignores options for which it does not have a matching command' do
        options = {unknown: initialization_value}
        commands = Commands.create_commands_for(options)

        expect(commands).to be_empty
      end
    end
  end

end
