# frozen_string_literal: true

Admin.create(
  name: "Admin",
  email: "admin@example.com",
  password: "password123",
  password_confirmation: "password123"
)

10.times do |i| # rubocop:disable Metrics/BlockLength
  merchant = Merchant.create(
    name: "Merchant #{i + 1}",
    email: "merchant#{i + 1}@example.com",
    status: "active",
    password: "password123",
    password_confirmation: "password123"
  )

  authenticate_transaction = Transactions::AuthorizeTransaction.create(
    merchant_id: merchant.id,
    amount: 100.0,
    status: "approved",
    customer_email: "auth#{i + 1}@example.com"
  )

  charge_transaction = Transactions::ChargeTransaction.create(
    merchant_id: merchant.id,
    referenced_transaction: authenticate_transaction,
    amount: 100.0,
    status: "approved",
    customer_email: "charge#{i + 1}@example.com"
  )

  Transactions::RefundTransaction.create(
    merchant_id: merchant.id,
    referenced_transaction: charge_transaction,
    amount: 100.0,
    status: "approved",
    customer_email: "charge#{i + 1}@example.com"
  )
end
