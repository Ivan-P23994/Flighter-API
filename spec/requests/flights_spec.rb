RSpec.describe 'Flights', type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, role: 'admin') }
  let(:flight) { create(:flight) }
  let(:company) { create(:company) }

  describe 'GET /api/flights' do
    before { create_list(:flight, 4) }

    context 'with unauthenticated user' do
      it 'response has status code :ok (200)' do
        get '/api/flights',
            headers: api_headers('invalid_token')

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :ok (200)' do
        get '/api/flights',
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['flights'].count).to eq(4)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'successfully returns a list of users with status code :ok (200)' do
        get '/api/flights',
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['flights'].count).to eq(4)
      end
    end
  end

  describe 'GET /flight/:id' do
    context 'with unauthenticated user' do
      it 'response has status code :ok (200)' do
        get "/api/flights/#{flight.id}",
            headers: api_headers('invalid_token')

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'returns a single flight' do
        get "/api/flights/#{flight.id}",
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['flight']['id']).to eq(flight.id)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'returns a single flight with status code: ok (200)' do
        get "/api/flights/#{flight.id}",
            headers: api_headers(admin.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['flight']['id']).to eq(flight.id)
      end
    end

    context 'with authenticated & unauthorized user and invalid values' do
      it 'response has status code :not_found (404)' do
        get '/api/flights/41',
            headers: api_headers(admin.token)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /flights' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        post '/api/flights/',
             params: {
               flight: { name: 'Masterdam Flight', arrives_at: DateTime.now + 1.year,
                         base_price: 23, departs_at: DateTime.now + 1.week,
                         company_id: company.id, no_of_seats: 214 }
             }.to_json,
             headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :forbidden (403)' do
        post '/api/flights/',
             params: {
               flight: { name: 'Masterdam Flight', arrives_at: DateTime.now + 1.year,
                         base_price: 23, departs_at: DateTime.now + 1.week,
                         company_id: company.id, no_of_seats: 214 }
             }.to_json,
             headers: api_headers(user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'creates a single flight with status code: created (201)' do
        post '/api/flights',
             params: {
               flight: { name: 'Masterdam Flight', arrives_at: DateTime.now + 1.year,
                         base_price: 23, departs_at: DateTime.now + 1.week,
                         company_id: company.id, no_of_seats: 214 }
             }.to_json,
             headers: api_headers(admin.token)

        expect(response).to have_http_status(:created)
        expect(json_body['flight']).to include('name' => 'Masterdam Flight')
        expect(flight.persisted?).to eq(true)
      end
    end

    context 'with authenticated & authorized user and invalid values' do
      it 'response has status code :bad_request (400)' do
        post '/api/flights',
             params: { flight: { name: nil } }.to_json,
             headers: api_headers(admin.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'PATCH /flights' do
    context 'with unthenticated user' do
      it 'response has status code :unauthorized (401)' do
        patch "/api/flights/#{flight.id}",
              params: { flight: { name: 'Coco Flight' } }.to_json,
              headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :forbidden (403)' do
        patch "/api/flights/#{flight.id}",
              params: { flight: { name: 'Coco Flight' } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'updates a flight with a status code :ok (200)' do
        patch "/api/flights/#{flight.id}",
              params: { flight: { name: 'Coco Flight' } }.to_json,
              headers: api_headers(admin.token)

        expect(response).to have_http_status(:ok)
        expect(flight.persisted?).to eq(true)
        expect(json_body['flight']['name']).to eq('Coco Flight')
      end
    end

    context 'with authenticated & authorized user and invalid values' do
      it 'response has status code :bad_request (400)' do
        patch "/api/flights/#{flight.id}",
              params: { flight: { name: nil } }.to_json,
              headers: api_headers(admin.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name'].count).to eq(1)
      end
    end
  end

  describe 'DELETE /api/flights/:id' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        delete "/api/flights/#{flight.id}",
               params: flight.to_json,
               headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :forbidden (403)' do
        delete "/api/flights/#{flight.id}",
               params: flight.to_json,
               headers: api_headers(user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'destroys designated flight instance' do
        delete "/api/flights/#{flight.id}",
               params: flight.to_json,
               headers: api_headers(admin.token)

        expect(Flight.all.count).to eq(0)
      end
    end

    context 'with authenticated & authorized user and invalid values' do
      it 'response has status code :not_found (404)' do
        delete '/api/flights/41',
               params: flight.to_json,
               headers: api_headers(admin.token)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
