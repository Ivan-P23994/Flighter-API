RSpec.describe 'Companies', type: :request do
  let(:user) { create(:user) }
  let(:company) { create(:company) }
  let(:admin) { create(:user, role: 'admin') }

  describe 'GET api/companies' do
    before { create_list(:company, 2) }

    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        get '/api/companies',
            headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :ok (200)' do
        get '/api/companies',
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['companies'].count).to eq(2)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'successfully returns a list of companies' do
        get '/api/companies',
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['companies'].count).to eq(2)
      end
    end
  end

  describe 'GET api/companies/:id' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        get "/api/companies/#{company.id}",
            headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'returns a single company with status code: ok (200)' do
        get "/api/companies/#{company.id}",
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['company']['id']).to eq(company.id)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'returns a single company with status code: ok (200)' do
        get "/api/companies/#{company.id}",
            headers: api_headers(admin.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['company']['id']).to eq(company.id)
      end
    end

    context 'with authenticated & authorized user and invalid values' do
      it 'response has status code :not_found (404)' do
        get '/api/companies/41',
            headers: api_headers(admin.token)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST api/companies' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        post '/api/companies',
             params: { company: { name: 'Play Lines' } }.to_json,
             headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :forbidden (403)' do
        post '/api/companies',
             params: { company: { name: 'K Airlines' } }.to_json,
             headers: api_headers(user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'creates a single flight with status code: created (201)' do
        post '/api/companies',
             params: { company: { name: 'K Airlines' } }.to_json,
             headers: api_headers(admin.token)

        expect(response).to have_http_status(:created)
        expect(json_body['company']).to include('name' => 'K Airlines')
        expect(company.persisted?).to eq(true)
      end
    end

    context 'with authenticated & authorized user and invalid values' do
      it 'response has status code :bad_request (400)' do
        post '/api/companies',
             params: { company: { name: nil } }.to_json,
             headers: api_headers(admin.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'PATCH api/companies' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        patch "/api/companies/#{company.id}",
              params: { company: { name: nil } }.to_json,
              headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :unauthorized (403)' do
        patch "/api/companies/#{company.id}",
              params: { company: { name: nil } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'updates a company with a status code :ok (200)' do
        patch "/api/companies/#{company.id}",
              params: { company: { name: 'Coco Company' } }.to_json,
              headers: api_headers(admin.token)

        expect(response).to have_http_status(:ok)
        expect(company.persisted?).to eq(true)
        expect(json_body['company']['name']).to eq('Coco Company')
      end
    end

    context 'with authenticated & authorized user and invalid values' do
      it 'response has status code :bad_request (400)' do
        patch "/api/companies/#{company.id}",
              params: { company: { name: nil } }.to_json,
              headers: api_headers(admin.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name'].count).to eq(1)
      end
    end
  end

  describe 'DELETE /api/companies/:id' do
    context 'with unauthenticated' do
      it 'response has status code :unauthorized (401)' do
        delete "/api/companies/#{company.id}",
               params: company.to_json,
               headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :forbidden (403)' do
        delete "/api/companies/#{company.id}",
               params: company.to_json,
               headers: api_headers(user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with authenticated & authorized user and valid value' do
      it 'destroys designated company instance' do
        delete "/api/companies/#{company.id}",
               params: company.to_json,
               headers: api_headers(admin.token)

        expect(Company.all.count).to eq(0)
      end
    end

    context 'with authenticated & authorized user and invalid value' do
      it 'response has status code :not_found (404)' do
        delete '/api/companies/41',
               params: company.to_json,
               headers: api_headers(admin.token)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
