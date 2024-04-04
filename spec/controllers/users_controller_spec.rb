# spec/controllers/users_controller_spec.rb

require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        post :create, params: { email: 'test@example.com', password: 'password', password_confirmation: 'password' }
        expect(response.status).to eq(201)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        post :create, params: { email: 'test@example.com', password: 'password', password_confirmation: 'wrong_password' }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:user) { create(:user) }

    before do
      token = JsonWebToken.encode(user_id: user.id)
      request.headers['Authorization'] = "Bearer #{token}"
    end

    context 'with valid parameters' do
      it 'updates the user' do
        patch :update, params: { id: user.id, name: 'Updated Name' }
        expect(response).to have_http_status(:ok)
        user.reload
        expect(user.name).to eq('Updated Name')
      end

      it 'returns a success message' do
        patch :update, params: { id: user.id, name: 'Updated Name' }
        expect(response.body).to include('User updated successfully')
      end
    end

    context 'with invalid parameters' do
      it 'does not update the user' do
        patch :update, params: { id: user.id, email: 'invalid_email' }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'returns an error message' do
        patch :update, params: { id: user.id, email: 'invalid_email' }
        expect(response.body).to include('Email is invalid')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create(:user) }
    
    before do
      token = JsonWebToken.encode(user_id: user.id)
      request.headers['Authorization'] = "Bearer #{token}"
    end

    it 'deletes the user' do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end

    it 'returns a success message' do
      delete :destroy, params: { id: user.id }
      expect(response.body).to include('User deleted successfully')
    end
  end
end
