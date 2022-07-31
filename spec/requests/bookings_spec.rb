RSpec.describe 'Booking', type: :request do
  let(:user) { create(:user) }
  let(:user1) { create(:user) }
  let(:flight) { create(:flight) }
  let(:booking) { create(:booking, user_id: user.id) }

  describe 'GET /api/bookings' do
    context 'with unauthenticated user' do
      before { create_list(:booking, 3) }

      it 'response has status code :unauthorized (401)' do
        get '/api/bookings',
            headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      before { create_list(:booking, 3) }

      it 'response has status code :ok (200)' do
        get '/api/bookings',
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      before { create_list(:booking, 3, user_id: user.id) }

      let(:user) { create(:user, role: 'admin') }

      it 'successfully returns a list of bookings with status code :ok (200)' do
        get '/api/bookings',
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['bookings'].count).to eq(3)
      end
    end
  end

  describe 'GET /api/booking/:id' do
    let(:booking) { create(:booking, user_id: user.id) }

    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        get "/api/bookings/#{booking.id}",
            headers: api_headers('invalid token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :forbidden (403)' do
        get "/api/bookings/#{booking.id}",
            headers: api_headers(user1.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'returns a single booking with status code :ok (201)' do
        get "/api/bookings/#{booking.id}",
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['booking']['id']).to eq(booking.id)
      end
    end

    context 'with authenticated & unauthorized and invalid values' do
      it 'response has status code :not_found (404)' do
        get '/api/bookings/42',
            headers: api_headers(user.token)

        expect(response).to have_http_status :not_found
      end
    end
  end

  describe 'POST /api/bookings' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 232, seat_price: 1244,
                                  flight_id: flight.id,
                                  user_id: user.id } }.to_json,
             headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'creates a booking' do
        post '/api/bookings',
             params: { booking: { no_of_seats: 232, seat_price: 1244,
                                  flight_id: flight.id,
                                  user_id: user.id } }.to_json,
             headers: api_headers(user.token)

        expect(response).to have_http_status(:created)
        expect(json_body['booking']).to include('no_of_seats' => 232)
        expect(booking.persisted?).to eq(true)
      end
    end

    context 'with authenticated & authorized user and invalid values' do
      it 'response has status code :bad_request (400)' do
        post '/api/bookings',
             params: { booking: { no_of_seats: nil, user_id: user.id } }.to_json,
             headers: api_headers(user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors'].count).to eq(3)
      end
    end
  end

  describe 'PATCH /bookings' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        patch "/api/bookings/#{booking.id}",
              params: { booking: { no_of_seats: 231 } }.to_json,
              headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :unauthorized (403)' do
        patch "/api/bookings/#{booking.id}",
              params: { booking: { user_id: user1.id, no_of_seats: 231 } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'updates a booking with status code :ok (200)' do
        patch "/api/bookings/#{booking.id}",
              params: { booking: { no_of_seats: 231 } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(booking.persisted?).to eq(true)
        expect(json_body['booking']['no_of_seats']).to eq(231)
      end
    end

    context 'with authenticated user and invalid values' do
      it 'returns (400) :bad_request' do
        patch "/api/bookings/#{booking.id}",
              params: { booking: { no_of_seats: nil } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['no_of_seats'].count).to eq(2)
      end
    end
  end

  describe 'DELETE /api/bookings/:id' do
    context 'with unauthenticated user ' do
      it 'response has status code :unauthorized (401)' do
        delete "/api/bookings/#{booking.id}",
               params: booking.to_json,
               headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated & unauthorized user' do
      it 'response has status code :unauthorized (403)' do
        delete "/api/bookings/#{booking.id}",
               params: booking.to_json,
               headers: api_headers(user1.token)

        expect(response).to have_http_status(:forbidden)
      end
    end

    context 'with authenticated & authorized user and valid values' do
      it 'destroys a booking' do
        delete "/api/bookings/#{booking.id}",
               params: booking.to_json,
               headers: api_headers(user.token)

        expect(Booking.all.count).to eq(0)
      end
    end

    context 'with authenticated user and invalid values' do
      it 'response has status code :not_found (404)' do
        delete '/api/bookings/42',
               params: booking.to_json,
               headers: api_headers(user.token)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
