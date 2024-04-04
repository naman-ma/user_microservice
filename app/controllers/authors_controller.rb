# app/controllers/authors_controller.rb

class AuthorsController < ApplicationController
  before_action :authenticate_user

  # Your author-related actions (index, create, show, update, destroy) go here...

  private

  # Authenticate user using JWT token
  def authenticate_user
    unless current_user
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  # Extract user from JWT token
  def current_user
    @current_user ||= User.find_by(id: decoded_token[:user_id]) if decoded_token
  end

  # Decode JWT token
  def decoded_token
    token = request.headers['Authorization']&.split(' ')&.last
    begin
      JWT.decode(token, Rails.application.secrets.secret_key_base)
    rescue JWT::DecodeError
      nil
    end
  end
end
