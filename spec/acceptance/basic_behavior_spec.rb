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

  class Accomplishment
    include LazyDoc::DSL

    access :description

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
    access :father, default: 'Chuck Palahniuk'
    access :fight_club_rules, via: [:fightClub, :rules], extract: :title
    access :accomplishments, as: Accomplishment

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
  its(:father) { should == 'Chuck Palahniuk' }

  context 'friends' do
    let(:friends) { user.friends }

    specify { expect(friends.best_friend).to eq('Brad Pitt') }
    specify { expect(friends.lover).to eq('Helena Bonham Carter') }
  end

  its(:fight_club_rules) { should == ['You do not talk about Fight Club',
                                      'You DO NOT talk about Fight Club',
                                      'If someone says stop or goes limp, taps out the fight is over'] }

  context 'accomplishments' do
    let(:accomplishments) { user.accomplishments }

    specify { expect(accomplishments[0].description).to eq('Sold a lot of soap') }
    specify { expect(accomplishments[1].description).to eq('Started fight club with himself') }
    specify { expect(accomplishments[2].description).to eq('Blew up a bunch of credit card companies') }
  end
end
