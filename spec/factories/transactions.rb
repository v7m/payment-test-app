# frozen_string_literal: true

require "faker"

FactoryBot.define do
  factory :transaction do
    association :merchant
    customer_phone { Faker::PhoneNumber.phone_number }
    customer_email { Faker::Internet.email }

    traits_for_enum :status
  end

  factory :authorize_transaction, parent: :transaction, class: "Transactions::AuthorizeTransaction" do
    amount { 100.0 }
  end

  factory :charge_transaction, parent: :transaction, class: "Transactions::ChargeTransaction" do
    amount { 100.0 }
  end

  factory :charge_transaction_with_referenced, parent: :charge_transaction do
    before(:create) do |charge_transaction|
      unless charge_transaction.referenced_transaction
        authorize_transaction = create(:authorize_transaction, :approved, merchant: charge_transaction.merchant)
        charge_transaction.referenced_transaction = authorize_transaction
      end
    end
  end

  factory :refund_transaction, parent: :transaction, class: "Transactions::RefundTransaction" do
    amount { 100.0 }
  end

  factory :refund_transaction_with_referenced, parent: :refund_transaction do
    before(:create) do |refund_transaction|
      unless refund_transaction.referenced_transaction
        authorize_transaction = create(:authorize_transaction, :approved, merchant: refund_transaction.merchant)
        charge_transaction = create(:charge_transaction, :approved, merchant: refund_transaction.merchant,
                                                                    referenced_transaction: authorize_transaction)
        refund_transaction.referenced_transaction = charge_transaction
      end
    end
  end

  factory :reversal_transaction, parent: :transaction, class: "Transactions::ReversalTransaction" do
  end

  factory :reversal_transaction_with_referenced, parent: :reversal_transaction do
    before(:create) do |reversal_transaction|
      unless reversal_transactionost.referenced_transaction
        authorize_transaction = create(:authorize_transaction, :approved, merchant: reversal_transaction.merchant)
        reversal_transaction.referenced_transaction = authorize_transaction
      end
    end
  end
end
