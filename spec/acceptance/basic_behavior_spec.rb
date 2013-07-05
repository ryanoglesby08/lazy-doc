require_relative '../spec_helper'

describe 'basic behavior with a simple JSON document' do
  class TestLazyDoc
    include LazyDoc::DSL

    find :foo, by: :foo

    def initialize(json)
      init(json)
    end

  end

  it 'lazily parses it' do
    json = '{"foo":"bar"}'

    lazy_doc = TestLazyDoc.new(json)

    expect(lazy_doc.foo).to eq('bar')
  end
end