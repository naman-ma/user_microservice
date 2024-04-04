class SessionsController < ApplicationController
  skip_before_action :authenticate_request, only: [:create, :destroy]

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token,user:user }, status: :created
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def destroy
    render json: { message: 'Logged out successfully' }, status: :ok
  end
end
