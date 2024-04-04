require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    let!(:user) { create(:user, email: 'test@example.com', password: 'password') }

    context 'with valid credentials' do
      it 'returns authentication token' do
        post :create, params: { email: 'test@example.com', password: 'password' }
        expect(response).to have_http_status(:created)
        json_response = JSON.parse(response.body)
        expect(json_response['token']).not_to be_nil
      end
    end

    context 'with invalid credentials' do
      it 'returns unauthorized error' do
        post :create, params: { email: 'test@example.com', password: 'wrong_password' }
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'returns success message' do
      delete :destroy
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq('Logged out successfully')
    end
  end
end
