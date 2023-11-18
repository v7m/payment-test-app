# frozen_string_literal: true

require "faker"

FactoryBot.define do
  factory :merchant do
    name { Faker::Name.first_name }
    description { Faker::Lorem.sentence }
    email { Faker::Internet.email }

    traits_for_enum :status
  end
end
