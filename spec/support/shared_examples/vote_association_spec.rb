RSpec.shared_examples 'vote association' do
  it { should have_many(:votes).dependent(:destroy) }
end
