# frozen_string_literal: true

require "rails_helper"

describe Merchant, type: :model do
  context "for associations" do
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:authorize_transactions).class_name("Transactions::AuthorizeTransaction") }
    it { is_expected.to have_many(:charge_transactions).class_name("Transactions::ChargeTransaction") }
    it { is_expected.to have_many(:refund_transactions).class_name("Transactions::RefundTransaction") }
    it { is_expected.to have_many(:reversal_transactions).class_name("Transactions::ReversalTransaction") }

    context "when deleting with associated transactions" do
      let!(:merchant) { create(:merchant, :active) }

      context "when associated transactions are present" do
        before do
          create(:authorize_transaction, :approved, merchant:)
        end

        it "does not allow deletion of merchant" do
          expect { merchant.destroy }.not_to change(described_class, :count)
          expect(merchant.errors[:base]).to include("Cannot delete record because dependent transactions exist")
        end
      end

      context "when associated transactions are not present" do
        it "allows deletion of merchant" do
          expect { merchant.destroy }.to change(described_class, :count).by(-1)
          expect(described_class.where(id: merchant.id)).not_to exist
        end
      end
    end
  end

  context "for validations" do
    it { is_expected.to validate_presence_of(:total_transaction_sum) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to define_enum_for(:status).with_values(inactive: 0, active: 1) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to validate_email_format_of(:email) }
  end
end
