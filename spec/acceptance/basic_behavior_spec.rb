require_relative '../spec_helper'

describe 'basic behavior with a simple JSON document' do
  class Friends
    include LazyDoc::DSL

    access :best_friend, via: :bestFriend
    access :lover

    def initialize(json)
      lazily_embed(json)
    end
  end

  class User
    include LazyDoc::DSL

    access :name
    access :phone, :zip
    access :home_town
    access :address, via: :streetAddress
    access :job_title, via: [:profile, :occupation, :title]
    access :born_on, via: [:profile, :bornOn], finally: lambda { |born_on| born_on.to_i }
    access :friends, as: Friends

    def initialize(json)
      lazily_embed(json)
    end

  end

  let(:json_file) { File.read(File.join(File.dirname(__FILE__), 'support/user.json')) }

  subject(:user) { User.new(json_file) }

  its(:name) { should == 'Tyler Durden' }
  its(:phone) { should == '288-555-0153' }
  its(:zip) { should == '00000' }
  its(:address) { should == 'Paper Street' }
  its(:job_title) { should == 'Soap Maker' }
  its(:born_on) { should == 1999 }
  specify { expect { user.home_town }.to raise_error(LazyDoc::AttributeNotFoundError) }

  context 'friends' do
    let(:friends) { user.friends }

    specify { expect(friends.best_friend).to eq('Brad Pitt') }
    specify { expect(friends.lover).to eq('Helena Bonham Carter') }
  end
end
