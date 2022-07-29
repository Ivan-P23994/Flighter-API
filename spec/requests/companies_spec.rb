RSpec.describe 'Companies', type: :request do
  let(:user) { create(:user) }
  let(:company) { create(:company) }

  describe 'GET api/companies' do
    before { create_list(:company, 2) }

    it 'successfully returns a list of companies' do
      get '/api/companies',
          headers: api_headers(user.token)

      expect(response).to have_http_status(:ok)
      expect(json_body['companies'].count).to eq(2)
    end
  end

  describe 'GET api/companies/:id' do
    it 'returns a single company' do
      get "/api/companies/#{company.id}",
          headers: api_headers(user.token)

      expect(response).to have_http_status(:ok)
      expect(json_body['company']['id']).to eq(company.id)
    end
  end

  describe 'POST api/companies' do
    context 'when params are valid' do
      it 'creates a company' do
        post '/api/companies',
             params: { company: { name: 'K Airlines' } }.to_json,
             headers: api_headers(user.token)

        expect(response).to have_http_status(:created)
        expect(json_body['company']).to include('name' => 'K Airlines')
        expect(company.persisted?).to eq(true)
      end
    end

    context 'when params are invalid' do
      it 'return 400 Bad Request' do
        post '/api/companies',
             params: { company: { name: nil } }.to_json,
             headers: api_headers(user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'PATCH api/companies' do
    context 'when params are valid' do
      it 'updates a company' do
        patch "/api/companies/#{company.id}",
              params: { company: { name: 'Coco Company' } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(company.persisted?).to eq(true)
        expect(json_body['company']['name']).to eq('Coco Company')
      end
    end

    context 'when params are invalid' do
      it 'updates a company' do
        patch "/api/companies/#{company.id}",
              params: { company: { name: nil } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name'].count).to eq(1)
      end
    end
  end

  describe 'DELETE /api/companies/:id' do
    it 'destroys a company' do
      delete "/api/companies/#{company.id}",
             params: company.to_json,
             headers: api_headers(user.token)

      expect(Company.all.count).to eq(0)
    end
  end
end
