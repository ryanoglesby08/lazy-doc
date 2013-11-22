require_relative '../../spec_helper'

module LazyDoc
  describe Collection do
    class FooBar
      include LazyDoc::DSL

      access :foo

      def initialize(json)
        lazily_embed(json)
      end
    end

    let(:json) { '[{"foo": "bar"}, {"foo": "blarg"}, {"foo": "wibble"}]' }

    let(:collection) { LazyDoc::Collection.build(json, FooBar) }

    it 'is an Enumerable' do
      collection.each do |foo_bar|
        expect(foo_bar).to be_a FooBar
      end
    end

    context 'when the expected document collection is actually a single element' do
      let(:json) { '{"foo": "bar"}' }

      specify { expect(collection).to have(1).element }
      specify { expect(collection.first).to be_a FooBar }
    end

  end

end