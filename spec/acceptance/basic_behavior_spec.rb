require_relative '../spec_helper'

describe 'basic behavior with a simple JSON document' do
  class User
    include LazyDoc::DSL

    access :name
    access :address, via: :streetAddress
    access :job_title, via: [:profile, :occupation, :title]
    access :born_on, via: [:profile, :bornOn], finally: lambda { |born_on| born_on.to_i }

    def initialize(json)
      lazily_embed(json)
    end

  end

  let(:json_file) { File.read(File.join(File.dirname(__FILE__), 'support/user.json')) }

  subject { User.new(json_file) }

  its(:name) { should == 'Tyler Durden' }
  its(:address) { should == 'Paper Street' }
  its(:job_title) { should == 'Soap Maker' }
  its(:born_on) { should == 1999 }
end