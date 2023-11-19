# frozen_string_literal: true

require "faker"

FactoryBot.define do
  factory :merchant do
    name { Faker::Name.first_name }
    description { Faker::Lorem.sentence }
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }

    traits_for_enum :status
  end
end
