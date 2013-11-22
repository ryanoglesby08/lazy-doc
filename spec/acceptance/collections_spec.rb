require_relative '../spec_helper'

describe 'behavior when the JSON is an array' do
  class LotrCharacter
    include LazyDoc::DSL

    access :name, :race

    def initialize(json)
      lazily_embed(json)
    end
  end

  let(:json_file) { File.read(File.join(File.dirname(__FILE__), 'support/lotr_characters.json')) }

  subject(:users) { LazyDoc::Collection.build(json_file, LotrCharacter) }

  context 'frodo' do
    let(:frodo) { users[0] }

    specify { expect(frodo.name).to eq('Frodo Baggins') }
    specify { expect(frodo.race).to eq('Hobbit') }
  end

  context 'sam' do
    let(:sam) { users[1] }

    specify { expect(sam.name).to eq('Samwise Gamgee') }
    specify { expect(sam.race).to eq('Hobbit') }
  end

  context 'gandolf' do
    let(:gandolf) { users[2] }

    specify { expect(gandolf.name).to eq('Gandolf the Grey') }
    specify { expect(gandolf.race).to eq('Wizard') }
  end
end