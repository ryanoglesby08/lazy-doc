require_relative '../../../spec_helper'

module LazyDoc
  describe Commands::FinallyCommand do
    let(:value) { 'hello world' }

    context 'acts like a Command' do
      subject(:command) { Commands::FinallyCommand.new(nil) }

      it_behaves_like 'the Command interface'
    end

    it 'transforms the supplied value with the supplied transformation' do
      transformation = lambda { |value| value.upcase }
      finally = Commands::FinallyCommand.new(transformation)

      final_value = finally.execute(value)

      expect(final_value).to eq('HELLO WORLD')
    end

    it 'uses a no op transformation when the supplied transformation is blank' do
      finally = Commands::FinallyCommand.new(nil)

      final_value = finally.execute(value)

      expect(final_value).to eq('hello world')
    end
  end
end