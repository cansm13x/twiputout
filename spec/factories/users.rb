FactoryBot.define do
  factory :user do
    user_name              { 'username' }
    email                  { Faker::Internet.free_email }
    password               { '12345k' }
    password_confirmation  { password }
  end
end
