RSpec.describe 'Flights', type: :request do
  describe 'GET api/flights' do
    before { create_list(:flight, 4) }

    it 'successfully returns a list of flights' do
      get '/api/flights'
      # binding.pry
      expect(response).to have_http_status(:ok)
      expect(json_body['flights'].count).to eq(4)
    end
  end

  describe 'Get /flight/:id' do
    let(:flight) { create(:flight) }

    it 'returns a single flight' do
      get "/api/flights/#{flight.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['flight']['id']).to eq(flight.id)
    end
  end

  describe 'POST /flights' do
    context 'when params are valid' do
      let(:flight) { create(:flight) }
      let(:company) { create(:company) }

      it 'creates a flight' do
        post '/api/flights',
             params: {
               flight: { name: 'Masterdam Flight', arrives_at: DateTime.now + 1.year,
                         base_price: 23, departs_at: DateTime.now + 1.week,
                         company_id: company.id, no_of_seats: 214 }
             }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:created)
        expect(json_body['flight']).to include('name' => 'Masterdam Flight')
        expect(flight.persisted?).to eq(true)
      end
    end

    context 'when params are invalid' do
      it 'return 400 Bad Request' do
        post '/api/flights',
             params: { flight: { name: nil } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('name')
      end
    end
  end

  describe 'PATCH /flights' do
    let(:flight) { create(:flight) }

    context 'when params are valid' do
      it 'updates a flight' do
        patch "/api/flights/#{flight.id}",
              params: { flight: { name: 'Coco Flight' } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:ok)
        expect(flight.persisted?).to eq(true)
        expect(json_body['flight']['name']).to eq('Coco Flight')
      end
    end

    context 'when params are invalid' do
      it 'updates an flight' do
        patch "/api/flights/#{flight.id}",
              params: { flight: { name: nil } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['name'].count).to eq(1)
      end
    end
  end

  describe 'DELETE /api/flights/:id' do
    let(:flight) { create(:flight) }

    it 'destroys an flight' do
      delete "/api/flights/#{flight.id}",
             params: flight.to_json,
             headers: api_headers

      expect(Flight.all.count).to eq(0)
    end
  end
end
