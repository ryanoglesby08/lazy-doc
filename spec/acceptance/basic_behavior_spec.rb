require_relative '../spec_helper'

describe 'basic behavior with a simple JSON document' do
  class User
    include LazyDoc::DSL

    access :name
    access :address, via: :streetAddress
    access :job_title, via: [:profile, :occupation, :title]

    def initialize(json)
      lazily_embed(json)
    end

  end

  it 'lazily parses it' do
    json = '{"name":"Tyler Durden", "streetAddress":"Paper Street", "profile":{"occupation":{"title":"Soap Maker","salary":0}}}'

    lazy_doc = User.new(json)

    expect(lazy_doc.name).to eq('Tyler Durden')
    expect(lazy_doc.address).to eq('Paper Street')
    expect(lazy_doc.job_title).to eq('Soap Maker')
  end
end