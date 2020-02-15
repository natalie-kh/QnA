require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://google.com').for(:url) }
  it { should_not allow_value('google.com').for(:url) }

  let(:gist_url) { 'https://gist.github.com/natalya-bogdanova/59312d83a6e67827186ee969dbd18ef8' }
  let(:not_gist_url) { 'https://github.com/natalya-bogdanova/' }

  context '#gist?' do
    it 'returns true for gist url' do
      expect(Link.new(url: gist_url)).to be_gist
    end

    it 'returns false for not gist' do
      expect(Link.new(url: not_gist_url)).not_to be_gist
    end
  end

  context '.default_scope' do
    let(:question) { create(:question) }
    let!(:links) { create_list(:link, 2, linkable: question) }

    it 'should sort array by created_at date' do
      expect(question.links.to_a).to be_eql [links.first, links.second]
    end
  end
end
