require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) do
    { 'CONTENT-TYPE': 'application/json',
      'ACCEPT': 'application/json' }
  end

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].last }
      let!(:answers) { create_list(:answer, 2, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq questions.size
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user_id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.first }
        let(:answer_response) { question_response['answers'].first }

        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq answers.size
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question_response) { json['question'] }
      let!(:links) { create_list(:link, 2, linkable: question) }
      let!(:comments) { create_list(:comment, 2, commentable: question) }
      let!(:files) { 2.times { question.files.attach(create_file_blob) } }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields' do
        %w[id title user_id body created_at updated_at].each do |attr|
          expect(question_response[attr]).to eq question.send(attr).as_json
        end
      end

      describe 'comments' do
        let(:comment) { comments.first }
        let(:comment_response) { question_response['comments'].first }

        it 'returns list of comments' do
          expect(question_response['comments'].size).to eq comments.size
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(comment_response[attr]).to eq comment.send(attr).as_json
          end
        end
      end

      describe 'links' do
        let(:link) { links.first }
        let(:link_response) { question_response['links'].first }

        it 'returns list of links' do
          expect(question_response['comments'].size).to eq links.size
        end

        it 'returns all public fields' do
          %w[id name url created_at updated_at].each do |attr|
            expect(link_response[attr]).to eq link.send(attr).as_json
          end
        end
      end

      describe 'files' do
        let(:file) { question.files.first }
        let(:file_response) { question_response['files'].first }

        it 'returns list of files' do
          expect(question_response['files'].size).to eq 2
        end

        it 'returns filename and URL' do
          expect(file_response['filename']).to eq file.name
          expect(file_response['path']).to eq rails_blob_path(file, only_path: true)
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id/answers' do
    let!(:question) { create(:question) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq answers.size
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user_id
      end
    end
  end

  describe 'POST /api/v1/questions/' do
    let(:headers) { { 'ACCEPT': 'application/json' } }
    let(:api_path) { '/api/v1/questions' }
    let(:question_response) { json['question'] }

    it_behaves_like 'API Authorizable' do
      let(:method) { :post }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:links) do
        [{ name: 'first link', url: 'https://first_link.com' },
         { name: 'second link', url: 'https://second_link.com' }]
      end
      let(:valid_params) do
        { access_token: access_token.token,
          question: { title: 'New Question Title', body: 'New Question Body', links_attributes: links } }
      end
      let(:invalid_params) do
        { access_token: access_token.token,
          question: { title: 'New Question Title', body: '', links_attributes: links } }
      end

      it_behaves_like 'API Validatable' do
        let(:method) { :post }
      end

      context 'with valid attributes' do
        let(:request) { post api_path, params: valid_params, headers: headers }

        it 'creates new question' do
          expect { request }.to change(Question, :count).by(1)
        end

        it 'returns 201 status' do
          request
          expect(response.status).to eq 201
        end

        describe 'links' do
          let(:link) { links.first }
          let(:link_response) { question_response['links'].first }

          it 'returns list of links' do
            request
            expect(question_response['links'].size).to eq links.size
          end
        end
      end
    end
  end

  describe 'PUT /api/v1/questions/:id' do
    let(:me) { create(:user) }
    let(:other_user) { create(:user) }
    let(:headers) { { 'ACCEPT': 'application/json' } }
    let!(:question) { create(:question, user: me) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :put }
    end

    context 'authorized' do
      let(:mine_access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }
      let(:valid_params) { { access_token: mine_access_token.token, question: { body: 'Updated Question Body' } } }
      let(:invalid_params) { { access_token: mine_access_token.token, question: { body: '' } } }
      let(:other_user_params) { { access_token: other_access_token.token, question: { body: 'Updated Question Body' } } }

      it_behaves_like 'API Validatable' do
        let(:method) { :put }
      end

      context 'with valid attributes' do
        before { put api_path, params: valid_params, headers: headers }

        it 'returns 204 status' do
          expect(response.status).to eq 204
        end

        it 'updates the question' do
          updated_question = Question.find(question.id)
          expect(updated_question.body).to eq 'Updated Question Body'
        end
      end

      context 'for not author' do
        before { put api_path, params: other_user_params, headers: headers }

        it 'returns 403 status' do
          expect(response.status).to eq 403
        end

        it 'does not update the answer' do
          updated_question = Question.find(question.id)
          expect(updated_question.body).to eq 'MyText'
        end
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:me) { create(:user) }
    let(:other_user) { create(:user) }
    let(:headers) { { 'ACCEPT': 'application/json' } }
    let!(:answer) { create(:answer, user: me) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }

    it_behaves_like 'API Authorizable' do
      let(:method) { :delete }
    end

    context 'authorized' do
      let(:mine_access_token) { create(:access_token, resource_owner_id: me.id) }
      let(:other_access_token) { create(:access_token, resource_owner_id: other_user.id) }

      context 'for answer author' do
        let(:request) { delete api_path, params: { access_token: mine_access_token.token }, headers: headers }

        it 'returns 204 status' do
          request
          expect(response.status).to eq 204
        end

        it 'deletes the answer' do
          expect { request }.to change(Answer, :count).by(-1)
        end
      end

      context 'for not author' do
        let(:request) { delete api_path, params: { access_token: other_access_token.token }, headers: headers }

        it 'returns 403 status' do
          request
          expect(response.status).to eq 403
        end

        it 'does not delete the answer' do
          expect { request }.to_not change(Answer, :count)
        end
      end
    end
  end
end
