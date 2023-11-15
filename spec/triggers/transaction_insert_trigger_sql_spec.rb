require "rails_helper"

describe TransactionInsertTriggerSQL do
  let(:merchant) { create(:merchant, :active) }
  let(:authorize_transaction) { create(:authorize_transaction, :approved, merchant: merchant) }

  context "when new Transactions::ChargeTransaction created" do
    it "encreases merchant's total_transaction_sum" do
      expect {
        create(:charge_transaction, :approved, merchant: merchant, authorize_transaction: authorize_transaction)
      }.to change { merchant.reload.total_transaction_sum }.by(100)
    end
  end

  context "when new Transactions::RefundTransaction created" do
    let!(:charge_transaction) do
      create(:charge_transaction, :approved, merchant: merchant, authorize_transaction: authorize_transaction)
    end

    it "decreases merchant's total_transaction_sum" do
      expect {
        create(:refund_transaction, :approved, merchant: merchant, charge_transaction: charge_transaction)
      }.to change { merchant.reload.total_transaction_sum }.by(-100.0)
    end
  end
end
