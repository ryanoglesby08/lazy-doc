require_relative '../../../spec_helper'

module LazyDoc
  describe Commands::DefaultValueCommand do
    context 'acts like a Command' do
      subject(:command) { Commands::DefaultValueCommand.new('default value') }

      it_behaves_like 'the Command interface'
    end

    let(:default) { Commands::DefaultValueCommand.new(default_value) }

    context 'when there is a default value' do
      let(:default_value) { 'default value' }

      it 'returns the default value when the supplied value is nil' do
        final_value = default.execute(nil)

        expect(final_value).to eq(default_value)
      end

      it 'returns the default value when the supplied value is empty' do
        final_value = default.execute('')

        expect(final_value).to eq(default_value)
      end

      it 'returns the supplied value when it is not nil' do
        final_value = default.execute('supplied value')

        expect(final_value).to eq('supplied value')
      end

    end

    context 'when there is not a default value' do
      let(:default_value) { nil }

      it 'returns the supplied value even when the supplied value is nil' do
        final_value = default.execute(nil)

        expect(final_value).to eq(nil)
      end

      it 'returns the supplied value even when the supplied value is empty' do
        final_value = default.execute('')

        expect(final_value).to eq('')
      end

      it 'returns the supplied value when the supplied value is not nil or empty' do
        final_value = default.execute('supplied value')

        expect(final_value).to eq('supplied value')
      end
    end

  end

end