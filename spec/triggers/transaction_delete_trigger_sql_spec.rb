require "rails_helper"

describe TransactionDeleteTriggerSQL do
  let(:merchant) { create(:merchant, :active) }
  let(:authorize_transaction) { create(:authorize_transaction, merchant: merchant) }
  let!(:charge_transaction) do 
    create(:charge_transaction, :approved, merchant: merchant, authorize_transaction: authorize_transaction)
  end

  context "when new Transactions::ChargeTransaction deleted" do
    it "decreases merchant's total_transaction_sum" do
      expect {
        charge_transaction.delete
      }.to change { merchant.reload.total_transaction_sum }.by(-100)
    end
  end

  context "when new Transactions::RefundTransaction deleted" do
    let!(:refund_transaction) do
      create(:refund_transaction, :approved, merchant: merchant, charge_transaction: charge_transaction)
    end

    it "increase merchant's total_transaction_sum" do
      expect {
        refund_transaction.delete
      }.to change { merchant.reload.total_transaction_sum }.by(100.0)
    end
  end
end
