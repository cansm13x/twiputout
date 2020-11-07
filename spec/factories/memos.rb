FactoryBot.define do
  factory :memo do
    memo_text   { Faker::Lorem.sentence }
    image       { Faker::Lorem.sentence }
    association :user
  end
end
