require_relative '../../spec_helper'

module LazyDoc
  describe DSL do
    describe '.find' do
      let(:json) { '{"foo":"bar"}' }

      subject(:test_find) { Object.new }

      before do
        class << test_find
          include LazyDoc::DSL
          find :foo, by: :foo
        end
      end

      it 'defines a method for the name of the attribute' do
        expect(test_find).to respond_to :foo
      end

      it 'defines a method that accesses a named json attribute' do
        test_find.init('{"foo":"bar"}')

        expect(test_find.foo).to eq("bar")
      end

      it 'caches the json attribute for subsequent access' do
        test_find.init(json)

        expect(test_find.foo).to eq("bar")

        test_find.instance_variable_set(:@json, nil)

        expect(test_find.foo).to eq("bar")
      end

    end

  end

end