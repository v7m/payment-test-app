require "rails_helper"

describe TransactionUpdateTriggerSQL do
  let(:merchant) { create(:merchant, :active) }
  let(:authorize_transaction) { create(:authorize_transaction, :approved, merchant: merchant) }

  context "when transaction's status changed" do
    context "when status was not 'approved' and changed to 'approved'" do
      let!(:charge_transaction) do 
        create(:charge_transaction, :refunded, merchant: merchant, authorize_transaction: authorize_transaction)
      end
      
      context "when Transactions::ChargeTransaction type" do
        context "when amount changed" do
          it "encreases merchant's total_transaction_sum" do
            expect {
              charge_transaction.update(status: Transaction.statuses[:approved], amount: 150)
            }.to change { merchant.reload.total_transaction_sum }.by(150)
          end
        end

        context "when amount didn't change" do
          it "encreases merchant's total_transaction_sum" do
            expect {
              charge_transaction.update(status: Transaction.statuses[:approved])
            }.to change { merchant.reload.total_transaction_sum }.by(100)
          end
        end
      end

      context "when Transactions::RefundTransaction type" do
        let!(:refund_transaction) do 
          create(:refund_transaction, :refunded, merchant: merchant, charge_transaction: charge_transaction)
        end

        context "when amount changed" do
          it "decreases merchant's total_transaction_sum" do
            expect {
              refund_transaction.update(status: Transaction.statuses[:approved], amount: 150)
            }.to change { merchant.reload.total_transaction_sum }.by(-150)
          end
        end

        context "when amount didn't change" do
          it "decreases merchant's total_transaction_sum" do
            expect {
              refund_transaction.update(status: Transaction.statuses[:approved])
            }.to change { merchant.reload.total_transaction_sum }.by(-100)
          end
        end
      end
    end

    context "when status was 'approved' and changed to not 'approved'" do
      let!(:charge_transaction) do 
        create(:charge_transaction, :approved, merchant: merchant, authorize_transaction: authorize_transaction)
      end
      
      context "when Transactions::ChargeTransaction type" do
        context "when amount changed" do
          it "decreases merchant's total_transaction_sum" do
            expect {
              charge_transaction.update(status: Transaction.statuses[:refunded], amount: 150)
            }.to change { merchant.reload.total_transaction_sum }.by(-100)
          end
        end

        context "when amount didn't change" do
          it "decreases merchant's total_transaction_sum" do
            expect {
              charge_transaction.update(status: Transaction.statuses[:refunded])
            }.to change { merchant.reload.total_transaction_sum }.by(-100)
          end
        end
      end

      context "when Transactions::RefundTransaction type" do
        let!(:refund_transaction) do 
          create(:refund_transaction, :approved, merchant: merchant, charge_transaction: charge_transaction)
        end

        context "when amount changed" do
          it "encreases merchant's total_transaction_sum" do
            expect {
              refund_transaction.update(status: Transaction.statuses[:refunded], amount: 150)
            }.to change { merchant.reload.total_transaction_sum }.by(100)
          end
        end

        context "when amount didn't change" do
          it "encreases merchant's total_transaction_sum" do
            expect {
              refund_transaction.update(status: Transaction.statuses[:refunded])
            }.to change { merchant.reload.total_transaction_sum }.by(100)
          end
        end
      end
    end
  end

  context "when transaction's status didn't change" do
    let!(:charge_transaction) do 
      create(:charge_transaction, :approved, merchant: merchant, authorize_transaction: authorize_transaction)
    end
    
    context "when Transactions::ChargeTransaction type" do
      it "encreases merchant's total_transaction_sum" do
        expect {
          charge_transaction.update(amount: 150)
        }.to change { merchant.reload.total_transaction_sum }.by(50)
      end
    end

    context "when Transactions::RefundTransaction type" do
      let!(:refund_transaction) do 
        create(:refund_transaction, :approved, merchant: merchant, charge_transaction: charge_transaction)
      end

      it "decreased merchant's total_transaction_sum" do
        expect {
          refund_transaction.update(amount: 150)
        }.to change { merchant.reload.total_transaction_sum }.by(-50)
      end
    end
  end
end
