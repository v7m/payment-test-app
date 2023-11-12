require 'faker'

FactoryBot.define do
  factory :merchants do
    name { Faker::Name.first_name }
    description  { Faker::Lorem.sentence }
    email { Faker::Internet.safe_email }

    traits_for_enum :status, %w[inactive active]
  end
end
