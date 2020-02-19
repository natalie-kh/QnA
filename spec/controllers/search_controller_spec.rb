require 'rails_helper'

RSpec.describe SearchController, type: :controller do
  describe 'GET #show' do
    it 'calls SearchService#new' do
      ThinkingSphinx::Test.run do
        expect(SearchService).to receive(:new).with('test', '').and_call_original

        get :show, params: { query: 'test', resource: '' }
      end
    end

    it 'renders show views' do
      ThinkingSphinx::Test.run do
        get :show, params: { query: 'test', resource: '' }

        expect(response).to render_template :show
      end
    end
  end
end
