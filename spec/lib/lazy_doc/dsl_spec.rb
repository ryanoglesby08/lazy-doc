require_relative '../../spec_helper'

module LazyDoc
  describe DSL do
    describe '.access' do
      let(:json) { '{"foo":"bar", "blarg":"wibble"}' }

      subject(:test_find) { Object.new }

      before do
        class << test_find
          include LazyDoc::DSL
        end
      end

      it 'defines a method for the name of the attribute' do
        test_find.singleton_class.access :foo

        expect(test_find).to respond_to :foo
      end

      it 'assumes the attribute name is sufficient to find the attribute' do
        test_find.singleton_class.access :foo
        test_find.lazily_embed(json)

        expect(test_find.foo).to eq("bar")
      end

      it 'caches the json attribute for subsequent access' do
        test_find.singleton_class.access :foo
        test_find.lazily_embed(json)

        expect(test_find.foo).to eq("bar")

        test_find.stub(:embedded_doc) { nil }

        expect(test_find.foo).to eq("bar")
      end

      it 'provides simple access to more than one attribute' do
        test_find.singleton_class.access :foo, :blarg
        test_find.lazily_embed(json)

        expect(test_find.foo).to eq("bar")
        expect(test_find.blarg).to eq("wibble")
      end

      it 'raises ArgumentError when more than one attribute is accessed with options' do
        expect { test_find.singleton_class.access :foo, :blarg, as: Foo}.to raise_error(ArgumentError, 'Options provided for multiple attributes')
      end

      context 'via' do
        it 'defines a method that accesses a named json attribute' do
          test_find.singleton_class.access :my_foo, via: :foo
          test_find.lazily_embed(json)

          expect(test_find.my_foo).to eq("bar")
        end

        it 'defines a method that accesses a named json attribute through a json path' do
          json = '{"bar": {"foo":"Hello World"}}'
          test_find.singleton_class.access :foo, via: [:bar, :foo]
          test_find.lazily_embed(json)

          expect(test_find.foo).to eq('Hello World')
        end
      end

      context 'finally' do
        it 'executes a block on the the attribute at the json path' do
          test_find.singleton_class.access :foo, finally: lambda { |foo| foo.upcase }
          test_find.lazily_embed(json)

          expect(test_find.foo).to eq('BAR')
        end
      end

      context 'as' do
        let(:json) { '{"foo": {"bar": "Hello"}}'}

        class Foo
          include LazyDoc::DSL

          access :bar

          def initialize(json)
            lazily_embed(json)
          end
        end

        it 'embeds a sub-object into another user defined object' do
          test_find.singleton_class.access :foo, as: Foo
          test_find.lazily_embed(json)

          foo = test_find.foo

          expect(foo).to be_a(Foo)
          expect(foo.bar).to eq('Hello')
        end

        it 'calls the finally method on the sub-object defined by "as"' do
          class Foo
            def bar_baz; bar + ' World' end
          end
          test_find.singleton_class.access :foo, as: Foo, finally: lambda { |foo| foo.bar_baz }
          test_find.lazily_embed(json)

          expect(test_find.foo).to eq('Hello World')
        end
      end

      context 'default' do
        it 'returns the default value when the json value is null' do
          json = '{"foo": null}'
          test_find.singleton_class.access :foo, default: 'hello world'
          test_find.lazily_embed(json)

          expect(test_find.foo).to eq('hello world')
        end

        it 'returns the json value when the json value is not null' do
          test_find.singleton_class.access :foo, default: 'hello world'
          test_find.lazily_embed(json)

          expect(test_find.foo).to eq('bar')
        end
      end

    end

  end

end
