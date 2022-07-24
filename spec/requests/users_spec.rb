RSpec.describe 'Users', type: :request do
  describe 'GET api/users' do
    before { create_list(:user, 4) }

    it 'successfully returns a list of users' do
      get '/api/users'

      expect(response).to have_http_status(:ok)
      expect(json_body['users'].count).to eq(4)
    end
  end

  describe 'GET /users/:id' do
    let(:user) { create(:user) }

    it 'returns a single user' do
      get "/api/users/#{user.id}"

      expect(response).to have_http_status(:ok)
      expect(json_body['user']['id']).to eq(user.id)
    end
  end

  describe 'POST /users' do
    context 'when params are valid' do
      let(:user) { create(:user) }

      it 'creates an user' do
        post '/api/users',
             params: { user: { first_name: 'Ash', email: "pok\@gmail.com" } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:created)
        expect(json_body['user']).to include('first_name' => 'Ash')
        expect(user.persisted?).to eq(true)
      end
    end

    context 'when params are invalid' do
      it 'return 400 Bad Request' do
        post '/api/users',
             params: { user: { first_name: 'Ash' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']).to include('email')
      end
    end
  end

  describe 'PATCH /users' do
    let(:user) { create(:user) }

    context 'when params are valid' do
      it 'updates an user' do
        patch "/api/users/#{user.id}",
              params: { user: { first_name: 'Coco' } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:ok)
        expect(user.persisted?).to eq(true)
        expect(json_body['user']['first_name']).to eq('Coco')
      end
    end

    context 'when params are invalid' do
      it 'updates an user' do
        patch "/api/users/#{user.id}",
              params: { user: { first_name: nil } }.to_json,
              headers: api_headers

        expect(response).to have_http_status(:bad_request)
        expect(json_body['errors']['first_name'].count).to eq(2)
      end
    end
  end

  describe 'DELETE /api/users/:id' do
    let(:user) { create(:user) }

    it 'destroys an user' do
      delete "/api/users/#{user.id}",
             params: user.to_json,
             headers: api_headers

      expect(User.all.count).to eq(0)
    end
  end
end
