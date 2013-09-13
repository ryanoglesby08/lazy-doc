require_relative '../../../spec_helper'

module LazyDoc
  describe Commands::ExtractCommand do
    context 'acts like a Command' do
      subject(:command) { Commands::ExtractCommand.new('attribute to extract') }

      it_behaves_like 'the Command interface'
    end

    it 'returns an array of the extracted attribute' do
      extract = Commands::ExtractCommand.new(:name)

      names = [{'name' => 'Brian'}, {'name' => 'Chris'}, {'name' => 'Mary'}]
      extracted_names = extract.execute(names)

      expect(extracted_names).to eq(['Brian', 'Chris', 'Mary'])
    end

    it 'returns the original value when there is no specified attribute to extract' do
      extract = Commands::ExtractCommand.new(nil)

      extracted_value = extract.execute('foo')

      expect(extracted_value).to eq('foo')
    end
  end
end
