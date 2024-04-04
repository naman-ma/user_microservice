# app/models/user.rb

class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8, message: "must be at least 8 characters long" },  on: :create
end
