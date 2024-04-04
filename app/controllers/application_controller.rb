require 'jwt'

class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    unless valid_token?
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def valid_token?
    token = request.headers['Authorization']&.split(' ')&.last
    return false unless token

    begin
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)
      @current_user = User.find(decoded_token.first['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      return false
    end

    true
  end

  def current_user
    @current_user
  end
end
