require_relative '../../spec_helper'

module LazyDoc
  describe DSL do
    describe '.find' do
      let(:json) { '{"foo":"bar"}' }

      subject(:test_find) { Object.new }

      before do
        class << test_find
          include LazyDoc::DSL
        end
      end

      it 'defines a method for the name of the attribute' do
        test_find.singleton_class.class_eval do
          find :foo
        end

        expect(test_find).to respond_to :foo
      end

      it 'defines a method that accesses a named json attribute' do
        test_find.singleton_class.class_eval do
          find :my_foo, by: :foo
        end
        test_find.init(json)

        expect(test_find.my_foo).to eq("bar")
      end

      it 'assumes the attribute name is sufficient to find the attribute' do
        test_find.singleton_class.class_eval do
          find :foo
        end
        test_find.init(json)

        expect(test_find.foo).to eq("bar")
      end

      it 'caches the json attribute for subsequent access' do
        test_find.singleton_class.class_eval do
          find :foo
        end
        test_find.init(json)

        expect(test_find.foo).to eq("bar")

        test_find.instance_variable_set(:@json, nil)

        expect(test_find.foo).to eq("bar")
      end


    end

  end

end