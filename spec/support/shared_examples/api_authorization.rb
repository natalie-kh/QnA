shared_examples_for 'API Authorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '1234' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'API Validatable' do
  context 'with invalid attributes' do
    before { do_request(method, api_path, params: invalid_params, headers: headers) }

    it 'returns 422 status' do
      expect(response.status).to eq 422
    end

    it 'returns a validation failure message' do
      expect(json['errors'])
        .to match(/Validation failed: Body can't be blank/)
    end
  end
end
