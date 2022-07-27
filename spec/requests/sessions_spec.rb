RSpec.describe 'Sessions', type: :request do
  describe 'POST api/sessions' do
    context 'when params are valid' do
      let(:user) { create(:user) }

      it 'creates a session' do
        post '/api/sessions',
             params: { session: { email: user.email, password: user.password } }.to_json,
             headers: api_headers
        binding.pry
        expect(response).to have_http_status(:created)
      end
    end

    context 'when params are not valid' do
      let(:user) { create(:user) }

      it 'returns a :bad_request response' do
        post '/api/sessions',
             params: { session: { email: user.email, password: 'wrong_password' } }.to_json,
             headers: api_headers
        binding.pry
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
