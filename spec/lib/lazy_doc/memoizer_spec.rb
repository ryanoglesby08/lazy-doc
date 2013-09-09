require_relative '../../spec_helper'

module LazyDoc
  describe Memoizer do
    let(:memoizer) { Memoizer.new }

    it 'returns the value of the block' do
      memoized_value = memoizer.memoize(:foo) { 'hello world' }

      expect(memoized_value).to eq('hello world')
    end

    it 'returns the original block value given for subsequent access to the attribute' do
      memoizer.memoize(:foo) { 'hello world' }

      memoized_value = memoizer.memoize(:foo) { :doesnt_matter }

      expect(memoized_value).to eq('hello world')
    end

  end
end
