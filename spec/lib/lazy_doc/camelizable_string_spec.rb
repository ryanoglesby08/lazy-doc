require_relative '../../spec_helper'

module LazyDoc
  describe CamelizableString do
    describe '#camelize' do
      it 'converts a string from snake_case to camelCase' do
        camelized_string = CamelizableString.new('snake_case').camelize

        expect(camelized_string).to eq('snakeCase')
      end

      it 'has no effect on a string with no underscores' do
        camelized_string = CamelizableString.new('snakecase').camelize

        expect(camelized_string).to eq('snakecase')
      end
    end

  end

end
