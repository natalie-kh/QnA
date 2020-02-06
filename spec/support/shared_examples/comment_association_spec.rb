RSpec.shared_examples 'comment association' do
  it { should have_many(:comments).dependent(:destroy) }
end
