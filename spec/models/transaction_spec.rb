# frozen_string_literal: true

require "rails_helper"

describe Transaction, type: :model do
  context "for associations" do
    it { is_expected.to belong_to(:merchant) }
  end

  context "for validations" do
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).allow_nil }
    it { is_expected.to define_enum_for(:status).with_values(approved: 0, reversed: 1, refunded: 2, error: 3) }
    it { is_expected.to validate_presence_of(:customer_email) }
    it { is_expected.to validate_email_format_of(:customer_email) }
  end

  context "for scopes" do
    let(:merchant) { create(:merchant, :active) }
    let(:authorize_transaction_approved) { create(:authorize_transaction, :approved, merchant:) }
    let(:authorize_transaction_reversed) { create(:authorize_transaction, :reversed, merchant:) }
    let(:charge_transaction_approved) do
      create(:charge_transaction, :approved, merchant:, referenced_transaction: authorize_transaction_approved)
    end
    let(:charge_transaction_reversed) do
      create(:charge_transaction, :reversed, merchant:, referenced_transaction: authorize_transaction_approved)
    end

    describe ".approved_authorize" do
      it "returns only approved authorize transactions" do
        expect(described_class.approved_authorize).to eq([authorize_transaction_approved])
      end
    end

    describe ".approved_revessed" do
      it "eturns only approved reversed transactions" do
        expect(described_class.approved_revessed).to eq([authorize_transaction_reversed])
      end
    end

    describe ".charge_authorize" do
      it "returns only approved charge transactions" do
        expect(described_class.charge_authorize).to eq([charge_transaction_approved])
      end
    end

    describe ".charge_reversed" do
      it "eturns only charge reversed transactions" do
        expect(described_class.charge_reversed).to eq([charge_transaction_reversed])
      end
    end
  end
end
