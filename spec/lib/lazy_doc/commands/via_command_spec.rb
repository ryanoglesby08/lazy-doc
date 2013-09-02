require_relative '../../../spec_helper'

module LazyDoc
  describe Commands::ViaCommand do
    context 'acts like a Command' do
      subject(:command) { Commands::ViaCommand.new(:foo) }

      it_behaves_like 'the Command interface'
    end

    it 'extracts an attribute from a document' do
      document = {'foo' => 'bar'}
      via = Commands::ViaCommand.new(:foo)

      final_value = via.execute(document)

      expect(final_value).to eq('bar')
    end

    it 'extracts a nested attribute from a document' do
      document = {'foo' => {'bar' => {'blarg' => 'baz'}}}
      via = Commands::ViaCommand.new([:foo, :bar, :blarg])

      final_value = via.execute(document)

      expect(final_value).to eq('baz')
    end

    it 'raises AttributeNotFoundError when the document does not contain the path' do
      document = {'foo' => {'bar' => {'blarg' => 'baz'}}}
      via = Commands::ViaCommand.new([:foo, :wizz])

      expect { via.execute(document) }.to raise_error(AttributeNotFoundError)
    end
  end
end