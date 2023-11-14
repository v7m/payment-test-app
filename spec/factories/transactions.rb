require 'faker'

FactoryBot.define do
  factory :transaction do
    association :merchant
    customer_phone  { Faker::PhoneNumber.phone_number }
    customer_email { Faker::Internet.email }

    traits_for_enum :status
  end

  factory :authorize_transaction, parent: :transaction, class: "Transactions::AuthorizeTransaction" do
    amount { 100.0 }
  end

  factory :charge_transaction, parent: :transaction, class: "Transactions::ChargeTransaction" do
    amount { 100.0 }
  end

  factory :refund_transaction, parent: :transaction, class: "Transactions::RefundTransaction" do
    amount { 100.0 }
  end

  factory :reversal_transaction, parent: :transaction, class: "Transactions::ReversalTransaction" do
  end
end