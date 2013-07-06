require_relative '../spec_helper'

describe 'basic behavior with a simple JSON document' do
  class TestLazyDoc
    include LazyDoc::DSL

    find :title
    find :name, by: :first_name

    def initialize(json)
      init(json)
    end

  end

  it 'lazily parses it' do
    json = '{"title":"Cool", "first_name":"Ryan"}'

    lazy_doc = TestLazyDoc.new(json)

    expect(lazy_doc.title).to eq('Cool')
    expect(lazy_doc.name).to eq('Ryan')
  end
end