# frozen_string_literal: true

require "rails_helper"

describe Transaction, type: :model do
  let(:merchant) { create(:merchant, :active) }

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
    let(:authorize_approved_transaction) { create(:authorize_transaction, :approved, merchant:) }
    let(:authorize_reversed_transaction) { create(:authorize_transaction, :reversed, merchant:) }
    let(:authorize_refundedd_transaction) { create(:authorize_transaction, :refunded, merchant:) }
    let(:authorize_error_transaction) { create(:authorize_transaction, :error, merchant:) }

    let(:charge_approved_transaction) do
      create(:charge_transaction, :approved, merchant:, referenced_transaction: authorize_approved_transaction)
    end
    let(:charge_reversed_transaction) do
      create(:charge_transaction, :reversed, merchant:, referenced_transaction: authorize_approved_transaction)
    end
    let(:charge_refunded_transaction) do
      create(:charge_transaction, :refunded, merchant:, referenced_transaction: authorize_approved_transaction)
    end
    let(:charge_error_transaction) do
      create(:charge_transaction, :error, merchant:, referenced_transaction: authorize_approved_transaction)
    end

    let(:reversal_approved_transaction) do
      create(:reversal_transaction, :approved, merchant:, referenced_transaction: authorize_approved_transaction)
    end
    let(:reversal_reversed_transaction) do
      create(:reversal_transaction, :reversed, merchant:, referenced_transaction: authorize_approved_transaction)
    end
    let(:reversal_refunded_transaction) do
      create(:reversal_transaction, :refunded, merchant:, referenced_transaction: authorize_approved_transaction)
    end
    let(:reversal_error_transaction) do
      create(:reversal_transaction, :error, merchant:, referenced_transaction: authorize_approved_transaction)
    end

    let(:refund_approved_transaction) do
      create(:refund_transaction, :approved, merchant:, referenced_transaction: charge_approved_transaction)
    end
    let(:refund_reversed_transaction) do
      create(:refund_transaction, :reversed, merchant:, referenced_transaction: charge_approved_transaction)
    end
    let(:refund_refunded_transaction) do
      create(:refund_transaction, :refunded, merchant:, referenced_transaction: charge_approved_transaction)
    end
    let(:refund_error_transaction) do
      create(:refund_transaction, :error, merchant:, referenced_transaction: charge_approved_transaction)
    end

    described_class.statuses.keys.each do |status|
      described_class::TRANSACTION_TYPES.each do |type|
        let(:scope_name) { "#{type.demodulize.underscore.split('_').first}_#{status}" }
        let(:transaction_name) { "#{scope_name}_transaction" }

        context ".#{type.demodulize.underscore.split('_').first}_#{status}" do
          it "returns only correct transactions for scope" do
            expect(described_class.public_send(scope_name)).to eq([public_send(transaction_name)])
          end
        end
      end
    end
  end

  context "for dynamic type methods" do
    Transaction::TRANSACTION_TYPES.each do |transaction_type|
      describe "##{transaction_type.demodulize.underscore}?" do
        let(:authorize_transaction) { create(:authorize_transaction, :approved, merchant:) }

        let(:charge_transaction) do
          create(:charge_transaction, :approved, merchant:, referenced_transaction: authorize_approved_transaction)
        end

        let(:reversal_transaction) do
          create(:reversal_transaction, :approved, merchant:, referenced_transaction: authorize_approved_transaction)
        end

        let(:refund_transaction) do
          create(:refund_transaction, :approved, merchant:, referenced_transaction: charge_approved_transaction)
        end

        let(:transaction_name) { transaction_type.demodulize.underscore }

        it "defines #{transaction_type.demodulize.underscore}?" do
          expect(authorize_transaction).to respond_to("#{transaction_name}?")
        end

        context "when the same transaction type" do
          let(:transaction) { build(transaction_name) }

          it "returns true for #{transaction_type.demodulize.underscore}?" do
            expect(transaction.public_send("#{transaction_name}?")).to be_truthy
          end
        end
      end
    end
  end
end
