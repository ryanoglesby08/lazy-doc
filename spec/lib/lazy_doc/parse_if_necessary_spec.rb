require_relative '../../spec_helper'

module LazyDoc
  describe ParseIfNecessary do
    class TestParseIfNecessary
      include ParseIfNecessary
    end

    let(:test_parser) { TestParseIfNecessary.new }

    it 'parses a JSON string' do
      hash = test_parser.parse_if_necessary('{"foo":"bar"}')

      expect(hash).to be_a Hash
      expect(hash['foo']).to eq('bar')
    end

    it 'does not parse a Hash' do
      JSON.should_not_receive(:parse)

      hash = test_parser.parse_if_necessary({foo: 'bar'})

      expect(hash).to be_a Hash
      expect(hash[:foo]).to eq('bar')
    end

    it 'does not parse an Array' do
      JSON.should_not_receive(:parse)

      array = test_parser.parse_if_necessary([{foo: 'bar'}, {foo: 'bang'}])

      expect(array).to be_an Array
      expect(array[0]).to eq({foo: 'bar'})
      expect(array[1]).to eq({foo: 'bang'})
    end

  end
end