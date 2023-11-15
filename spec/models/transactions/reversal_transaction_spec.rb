require "rails_helper"

describe Transactions::ReversalTransaction, type: :model do
  let(:merchant) { create(:merchant, :active) }

  context "associations" do
    it { is_expected.to belong_to(:authorize_transaction) }
  end

  context "validations" do
    describe "#no_charge_transaction" do
      let(:authorize_transaction) { create(:authorize_transaction, merchant: merchant) }

      context "when charge transaction does not exist" do
        let(:reversal_transaction) { build(:reversal_transaction, merchant: merchant, authorize_transaction: authorize_transaction) }

        it 'returns true and does not add error' do
          expect(reversal_transaction.valid?).to be_truthy
          expect(reversal_transaction.errors[:base]).to be_empty
        end
      end

      context "when charge transaction exist" do
        let(:reversal_transaction) { build(:reversal_transaction, merchant: merchant, authorize_transaction: authorize_transaction) }

        before do
          create(:charge_transaction, merchant: merchant, authorize_transaction: authorize_transaction)
        end

        it 'returns false and adds error' do
          error_message = "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction"

          expect(reversal_transaction.valid?).to be_falsey
          expect(reversal_transaction.errors[:base]).to eq([error_message])
        end
      end
    end
  end
end
