shared_examples 'the Command interface' do
  it 'responds to execute' do
    expect(command).to respond_to :execute
  end
end