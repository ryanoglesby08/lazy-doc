require_relative '../spec_helper'

describe 'basic behavior with a simple JSON document' do
  class User
    include LazyDoc::DSL

    find :name
    find :address, by: :street_address

    def initialize(json)
      init(json)
    end

  end

  it 'lazily parses it' do
    json = '{"name":"Tyler Durden", "street_address":"Paper Street"}'

    lazy_doc = User.new(json)

    expect(lazy_doc.name).to eq('Tyler Durden')
    expect(lazy_doc.address).to eq('Paper Street')
  end
end