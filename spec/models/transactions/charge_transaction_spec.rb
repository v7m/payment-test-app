require "rails_helper"

describe Transactions::ChargeTransaction, type: :model do
  let(:merchant) { create(:merchant, :active) }

  context "associations" do
    it { is_expected.to belong_to(:authorize_transaction) }
    it { is_expected.to have_many(:refund_transactions) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:amount) }

    describe "#no_reversal_transaction" do
      let(:authorize_transaction) { create(:authorize_transaction, merchant: merchant) }

      context "when reversal transaction does not exist" do
        let(:charge_transaction) { build(:charge_transaction, merchant: merchant, authorize_transaction: authorize_transaction) }

        it 'returns true and does not add error' do
          expect(charge_transaction.valid?).to be_truthy
          expect(charge_transaction.errors[:base]).to be_empty
        end
      end

      context "when reversal transaction exist" do
        let(:charge_transaction) { build(:charge_transaction, merchant: merchant, authorize_transaction: authorize_transaction) }

        before do
          create(:reversal_transaction, merchant: merchant, authorize_transaction: authorize_transaction)
        end

        it 'returns false and adds error' do
          error_message = "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction"

          expect(charge_transaction.valid?).to be_falsey
          expect(charge_transaction.errors[:base]).to eq([error_message])
        end
      end
    end
  end
end
