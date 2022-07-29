RSpec.describe 'Users', type: :request do
  let(:user) { create(:user) }

  describe 'GET api/users' do
    before { create_list(:user, 4) }

    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        get '/api/users',
            headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated user and valid values' do
      it 'successfully returns a list of users with status code :ok (200)' do
        get '/api/users',
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['users'].count).to eq(5)
      end
    end
  end

  describe 'GET /users/:id' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        get "/api/users/#{user.id}",
            headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated user and valid values' do
      it 'returns a single user with status code :ok (200)' do
        get "/api/users/#{user.id}",
            headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(json_body['user']['id']).to eq(user.id)
      end
    end

    context 'with authenticated user and invalid values' do
      it 'response has status code :not_found (404)' do
        get '/api/users/41',
            headers: api_headers(user.token)

        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /users' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        post '/api/users',
             params: { user: { first_name: 'Ash', email: 'pk\@l.com', password: 'meaey' } }.to_json,
             headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated user and valid values' do
      it 'creates a user with status code :created (201)' do
        post '/api/users',
             params: { user: { first_name: 'Ash', email: 'pk\@l.com', password: 'meaey' } }.to_json,
             headers: api_headers(user.token)

        expect(response).to have_http_status(:created)
        expect(json_body['user']).to include('first_name' => 'Ash')
        expect(user.persisted?).to eq(true)
      end
    end

    context 'with authenticated user and invalid values' do
      it 'response has status code :not_found (404)' do
        post '/api/users',
             params: { user: { first_name: 'Ash' } }.to_json,
             headers: api_headers(user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('email')
      end
    end
  end

  describe 'PATCH /users' do
    context 'with unauthenticated' do
      it 'response has status code :unauthorized (401)' do
        patch "/api/users/#{user.id}",
              params: { user: { first_name: 'Coco', password: 'jambalaja' } }.to_json,
              headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated user and valid values' do
      it 'updates a user with status code :ok (200)' do
        patch "/api/users/#{user.id}",
              params: { user: { first_name: 'Coco', password: 'jambalaja' } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
        expect(user.persisted?).to eq(true)
        expect(json_body['user']['first_name']).to eq('Coco')
      end
    end

    context 'with authenticated user and invalid values' do
      it 'response has status code :not_found (404)' do
        patch "/api/users/#{user.id}",
              params: { user: { first_name: nil } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['first_name'].count).to eq(2)
      end
    end

    context 'when password is valid' do
      it 'updates a users password' do
        patch "/api/users/#{user.id}",
              params: { user: { password: 'meow' } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when password is set to nil' do
      it 'does not update the user' do
        patch "/api/users/#{user.id}",
              params: { user: { password: nil } }.to_json,
              headers: api_headers(user.token)

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    context 'with unauthenticated user' do
      it 'response has status code :unauthorized (401)' do
        delete "/api/users/#{user.id}",
               params: user.to_json,
               headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with authenticated user and valid values' do
      it 'updates a user with status code :ok (200)' do
        delete "/api/users/#{user.id}",
               params: user.to_json,
               headers: api_headers(user.token)

        expect(User.all.count).to eq(0)
      end
    end

    context 'with authenticated user and invalid values' do
      it 'response has status code :not_found (404)' do
        delete '/api/users/41',
               params: user.to_json,
               headers: api_headers(user.token)

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
