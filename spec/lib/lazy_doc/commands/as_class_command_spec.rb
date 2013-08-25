require_relative '../../../spec_helper'

module LazyDoc
  describe Commands::AsClassCommand do
    class Foo
      def initialize(value)
      end
    end

    let(:value) { {foo: 'bar'} }

    context 'acts like a Command' do
      subject(:command) { Commands::AsClassCommand.new(Foo) }

      it_behaves_like 'the Command interface'
    end

    it 'constructs an object of the specified class' do
      as_class_command = Commands::AsClassCommand.new(Foo)

      as_class_value = as_class_command.execute(value)

      expect(as_class_value).to be_a Foo
    end

    it 'returns the original value when the specified class is blank' do
      as_class_command = Commands::AsClassCommand.new(nil)

      as_class_value = as_class_command.execute(value)

      expect(as_class_value).to eq(value)
    end

    it 'passes the value as json to the specified class' do
      as_class_command = Commands::AsClassCommand.new(Foo)

      Foo.should_receive(:new).with("{\"foo\":\"bar\"}")

      as_class_command.execute(value)
    end
  end
end