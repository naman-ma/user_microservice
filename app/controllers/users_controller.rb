# app/controllers/users_controller.rb

class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :login]

  # POST /users
  # Register a new user
  def create
    user = User.new(user_params)
    if user.save
      render json: { message: 'User registered successfully' }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # POST /users/login
  # Login an existing user
  def login
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      auth_token = JsonWebToken.encode(user_id: user.id)
      render json: { auth_token: auth_token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def update
    user = User.find(params[:id])
    if user.update(user_params)
      render json: { message: 'User updated successfully' }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /users/:id
  # Delete user account
  def destroy
    user = User.find(params[:id])
    user.destroy
    render json: { message: 'User deleted successfully' }, status: :ok
  end

  def verify_token
    render json: { success: true }
  end

  private

  def decode_token(token)
    # Decode the token using the shared secret/key
    JWT.decode(token, Rails.application.secret_key_base)
  end

  # Strong params for user registration
  def user_params
    params.permit(:email, :password, :password_confirmation,:name)
  end
end
