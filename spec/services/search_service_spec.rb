require 'rails_helper'

RSpec.describe SearchService do
  describe '.call' do
    it 'calls search for correct resource' do
      ThinkingSphinx::Test.run do
        SearchService::RESOURCES.each do |resource|
          expect(resource.classify.constantize).to receive(:search).with('test').and_call_original

          SearchService.call(query: 'test', resource: resource)
        end
      end
    end

    it 'calls search for ThinkingSphinx if resource empty' do
      ThinkingSphinx::Test.run do
        expect(ThinkingSphinx).to receive(:search).with('test').and_call_original

        SearchService.call(query: 'test')
      end
    end

    it 'calls search for ThinkingSphinx if resource wrong' do
      ThinkingSphinx::Test.run do
        expect(ThinkingSphinx).to receive(:search).with('test').and_call_original

        SearchService.call(query: 'test', resource: 'wrong_resource')
      end
    end
  end
end
