# frozen_string_literal: true

require "rails_helper"
require "models/concerns/referenced_transaction_merchant_validatable_spec"

describe Transactions::ChargeTransaction, type: :model do
  let(:merchant) { create(:merchant, :active) }

  context "for associations" do
    it { is_expected.to belong_to(:referenced_transaction).class_name("Transactions::AuthorizeTransaction") }
    it { is_expected.to have_many(:refund_transactions) }
  end

  context "for validations" do
    it_behaves_like "referenced transaction merchant validatable"

    it { is_expected.to validate_presence_of(:amount) }

    describe "#no_reversal_transaction" do
      let(:authorize_transaction) { create(:authorize_transaction, :approved, merchant:) }

      context "when reversal transaction does not exist" do
        let(:charge_transaction) do
          build(:charge_transaction, :approved, merchant:, referenced_transaction: authorize_transaction)
        end

        it "returns true and does not add error" do
          expect(charge_transaction).to be_valid
          expect(charge_transaction.errors[:base]).to be_empty
        end
      end

      context "when reversal transaction exist" do
        let(:charge_transaction) do
          build(:charge_transaction, :approved, merchant:, referenced_transaction: authorize_transaction)
        end

        before do
          create(:reversal_transaction, merchant:, referenced_transaction: authorize_transaction)
        end

        it "returns false and adds error" do
          error_message = "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction"

          expect(charge_transaction).to be_invalid
          expect(charge_transaction.errors[:base]).to eq([error_message])
        end
      end
    end
  end
end
