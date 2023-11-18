require "rails_helper"

describe Transactions::CreateTransactionFactory do
  let(:initialized_factory) { described_class.new(**transaction_params) }
  let!(:merchant) { create(:merchant, :active) }
  let(:merchant_id) { merchant.id }
  let(:status) { "approved" }
  let(:amount) { 100.0 }
  let(:customer_phone)  { Faker::PhoneNumber.phone_number }
  let(:customer_email) { Faker::Internet.email }
  let(:transaction_params) {
    {
      merchant_id: merchant_id,
      referenced_transaction_id: referenced_transaction_id,
      status: status,
      amount: amount,
      customer_email: customer_email,
      customer_phone: customer_phone
    }
  }

  describe "#create_authorize_transaction" do
    subject { initialized_factory.create_authorize_transaction }

    let(:referenced_transaction_id) { nil }

    it "calls Transactions::CreateAuthorizeTransactionService service" do
      expect(Transactions::CreateAuthorizeTransactionService).to receive(:call).with(**transaction_params)

      subject
    end
  end

  describe "#create_charge_transaction" do
    subject { initialized_factory.create_charge_transaction }

    let(:referenced_transaction) { create(:authorize_transaction, :approved, merchant: merchant) }
    let(:referenced_transaction_id) { referenced_transaction.id }

    it "calls Transactions::CreateChargeTransactionService service" do
      expect(Transactions::CreateChargeTransactionService).to receive(:call).with(**transaction_params)

      subject
    end
  end

  describe "#create_reversal_transaction" do
    subject { initialized_factory.create_reversal_transaction }

    let(:referenced_transaction) { create(:authorize_transaction, :approved, merchant: merchant) }
    let(:referenced_transaction_id) { referenced_transaction.id }

    it "calls Transactions::CreateReversalTransactionService service" do
      expect(Transactions::CreateReversalTransactionService).to receive(:call).with(**transaction_params)

      subject
    end
  end

  describe "#create_refund_transaction" do
    subject { initialized_factory.create_refund_transaction }

    let(:referenced_transaction) { create(:charge_transaction_with_referenced, :approved, merchant: merchant) }
    let(:referenced_transaction_id) { referenced_transaction.id }

    it "calls Transactions::CreateRefundTransactionService service" do
      expect(Transactions::CreateRefundTransactionService).to receive(:call).with(**transaction_params)

      subject
    end
  end
end
