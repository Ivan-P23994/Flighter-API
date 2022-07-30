RSpec.describe 'Session', type: :request do
  let(:user) { create(:user) }

  describe 'POST api/sessions' do
    context 'when params are valid' do
      it 'creates a session' do
        post '/api/session',
             params: { session: { email: user.email, password: user.password } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:created)
      end
    end

    context 'when params are not valid' do
      it 'returns a :bad_request response' do
        post '/api/session',
             params: { session: { email: user.email, password: 'wrong_password' } }.to_json,
             headers: api_headers

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'DELETE api/sessions/:id' do
    context 'when user is unauthorized' do
      it 'returns a :forbidden response' do
        delete "/api/session/#{user.id}",
               headers: api_headers('invalid_token')

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when params are valid' do
      it 'deletes the current session' do
        delete "/api/session/#{user.id}",
               headers: api_headers(user.token)

        expect(response).to have_http_status(:no_content)
      end
    end
  end
end
