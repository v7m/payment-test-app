# frozen_string_literal: true

require "faker"

FactoryBot.define do
  factory :admin do
    name { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { "password123" }
    password_confirmation { "password123" }
  end
end
