# frozen_string_literal: true

require "rails_helper"
require "models/concerns/referenced_transaction_merchant_validatable_spec"

describe Transactions::ReversalTransaction, type: :model do
  let(:merchant) { create(:merchant, :active) }

  context "for associations" do
    it { is_expected.to belong_to(:referenced_transaction).class_name("Transactions::AuthorizeTransaction") }
  end

  context "for validations" do
    it_behaves_like "referenced transaction merchant validatable"

    describe "#no_charge_transaction" do
      let(:authorize_transaction) { create(:authorize_transaction, :approved, merchant:) }

      context "when charge transaction does not exist" do
        let(:reversal_transaction) do
          build(:reversal_transaction, :approved, merchant:, referenced_transaction: authorize_transaction)
        end

        it "returns true and does not add error" do
          expect(reversal_transaction).to be_valid
          expect(reversal_transaction.errors[:base]).to be_empty
        end
      end

      context "when charge transaction exist" do
        let(:reversal_transaction) do
          build(:reversal_transaction, :approved, merchant:, referenced_transaction: authorize_transaction)
        end

        before do
          create(:charge_transaction, merchant:, referenced_transaction: authorize_transaction)
        end

        it "returns false and adds error" do
          error_message = "An AuthorizeTransaction can only have either ChargeTransaction or ReversalTransaction"

          expect(reversal_transaction).to be_invalid
          expect(reversal_transaction.errors[:base]).to eq([error_message])
        end
      end
    end
  end
end
