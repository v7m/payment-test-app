require "rails_helper"

describe Transaction, type: :model do
  context "associations" do
    it { is_expected.to belong_to(:merchant) }
    it { is_expected.to belong_to(:referenced_transaction).class_name("Transaction").optional }
    it { is_expected.to have_many(:follow_transactions).class_name("Transaction") }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).allow_nil }
    it { is_expected.to define_enum_for(:status).with_values(approved: 0, reversed: 1, refunded: 2, error: 3) }
    it { is_expected.to validate_presence_of(:customer_email) }
    it { is_expected.to validate_email_format_of(:customer_email) }

    describe "#referenced_transactions_statuses" do
      let(:merchant) { create(:merchant, :active) }
      let(:charge_transaction) do
        build(:charge_transaction, :approved, merchant: merchant, authorize_transaction: authorize_transaction)
      end

      context "when referenced transaction has appropriate statuses" do
        shared_examples "valid_transaction" do |status|
          let(:authorize_transaction) { create(:authorize_transaction, status, merchant: merchant) }

          context "when #{status} status" do
            it "returns true and does not add error" do
              expect(charge_transaction.valid?).to be_truthy
              expect(charge_transaction.errors[:base]).to be_empty
            end
          end
        end

        %i(approved refunded).each do |status|
          it_behaves_like "valid_transaction", status
        end
      end

      context "when referenced transaction has inappropriate statuses" do
        shared_examples "invalid_transaction" do |status|
          let(:authorize_transaction) { create(:authorize_transaction, status, merchant: merchant) }

          context "when #{status} status" do
            it "returns true and does not add error" do
              error_message = "Referenced transaction has inappropriate status. " \
                              "Valid statuses: #{Transaction::PERMITTED_REFERENCE_STATUSES.join(", ")}"

              expect(charge_transaction.valid?).to be_falsey
              expect(charge_transaction.errors[:base]).to eq([error_message])
            end
          end
        end

        %i(reversed error).each do |status|
          it_behaves_like "invalid_transaction", status
        end
      end
    end
  end
end
