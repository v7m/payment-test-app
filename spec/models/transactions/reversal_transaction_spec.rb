require "rails_helper"
require "models/concerns/referenced_transaction_merchant_validatable_spec"

describe Transactions::ReversalTransaction, type: :model do
  let(:merchant) { create(:merchant, :active) }

  context "associations" do
    it { is_expected.to belong_to(:referenced_transaction).class_name("Transactions::AuthorizeTransaction") }
  end

  context "validations" do
    it_behaves_like "referenced transaction merchant validatable"

    describe "#no_charge_transaction" do
      let(:authorize_transaction) { create(:authorize_transaction, :approved, merchant: merchant) }

      context "when charge transaction does not exist" do
        let(:reversal_transaction) { build(:reversal_transaction, :approved, merchant: merchant, referenced_transaction: authorize_transaction) }

        it 'returns true and does not add error' do
          expect(reversal_transaction.valid?).to be_truthy
          expect(reversal_transaction.errors[:base]).to be_empty
        end
      end

      context "when charge transaction exist" do
        let(:reversal_transaction) { build(:reversal_transaction, :approved, merchant: merchant, referenced_transaction: authorize_transaction) }

        before do
          create(:charge_transaction, merchant: merchant, referenced_transaction: authorize_transaction)
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
