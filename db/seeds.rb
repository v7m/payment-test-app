# frozen_string_literal: true

10.times do |i|
  Merchant.create(
    name: "Merchant #{i + 1}",
    email: "merchant#{i + 1}@example.com",
    status: "active",
    password: "password123",
    password_confirmation: "password123"
  )
end
