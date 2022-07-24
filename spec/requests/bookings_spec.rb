RSpec.describe 'Booking', type: :request do
  describe 'GET api/booking' do
    before { create_list(:booking, 3) }

    it 'successfully returns a list of bookings' do
      get '/api/bookings'

      expect(response).to have_http_status(:ok)
      expect(json_body['bookings'].count).to eq(3)
    end
  end

  describe 'GET /bookings/:id' do
    let(:booking) { create(:booking) }

    it 'returns a single booking' do
      get "/api/bookings/#{booking.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['bookings']['id']).to eq(booking.id)
    end
  end

  describe 'POST /bookings' do
    context 'when params are valid' do
      let(:booking) { create(:booking) }
      let(:flight) { create(:flight) }
      let(:user) { create(:user) }

      it 'creates a booking' do
        booking.id = 323
        post '/api/bookings',
             params: { booking: { no_of_seats: 232, seat_price: 1244,
                                  flight_id: flight.id,
                                  user_id: user.id } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:created)
        expect(json_body['bookings']).to include('no_of_seats' => 232)
        expect(booking.persisted?).to eq(true)
      end
    end

    context 'when params are invalid' do
      it 'return 400 Bad Request' do
        post '/api/bookings',
             params: { booking: { user_id: 1 } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors'].count).to eq(4)
      end
    end
  end

  describe 'PATCH /bookings' do
    let(:booking) { create(:booking) }

    context 'when params are valid' do
      it 'updates an booking' do
        patch "/api/bookings/#{booking.id}",
              params: { booking: { no_of_seats: 231 } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:ok)
        expect(booking.persisted?).to eq(true)
        expect(json_body['bookings']['no_of_seats']).to eq(231)
      end
    end

    context 'when params are invalid' do
      it 'updates a booking' do
        patch "/api/bookings/#{booking.id}",
              params: { booking: { no_of_seats: nil } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['no_of_seats'].count).to eq(2)
      end
    end
  end

  describe 'DELETE /api/bookings/:id' do
    let(:booking) { create(:booking) }

    it 'destroys an booking' do
      delete "/api/bookings/#{booking.id}",
             params: booking.to_json,
             headers: api_headers

      expect(Booking.all.count).to eq(0)
    end
  end
end
