# spec/factories/users.rb

FactoryBot.define do
  factory :user do
    email { 'test@example.com' }
    password { 'password' }
    name { 'name' }
  end
end

