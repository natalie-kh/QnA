require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://google.com').for(:url) }
  it { should_not allow_value('google.com').for(:url) }

  let(:gist_url) { 'https://gist.github.com/natalya-bogdanova/59312d83a6e67827186ee969dbd18ef8' }
  let(:not_gist_url) { 'https://github.com/natalya-bogdanova/' }
  let(:not_found_gist_url) { 'https://gist.github.com/natalya-bogdanova/59312d83a6e67827' }
  let(:gist) { Link.new(url: gist_url) }
  let(:not_found_gist) { Link.new(url: not_found_gist_url) }
  let(:not_gist) { Link.new(url: not_gist_url) }


  context '#gist?' do
    it 'returns true for gist url' do
      expect(Link.new(url: gist_url)).to be_gist
    end

    it 'returns false for not gist' do
      expect(Link.new(url: not_gist_url)).not_to be_gist
    end
  end

  context '#gist_content' do
    it 'returns content for gist' do
      expect(gist.gist_content).to include "I'm a gist"
    end

    it 'returns Not a gist for wrong_gist_url' do
      expect(not_found_gist.gist_content).to include 'Gist not found'
    end
  end
end
