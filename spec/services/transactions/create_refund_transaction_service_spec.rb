# frozen_string_literal: true

require "rails_helper"
require "faker"
require "shared_examples/create_transaction_shared_examples"
require "shared_examples/transaction_shared_context"

describe Transactions::CreateRefundTransactionService do
  subject(:service_call) { described_class.call(**transaction_params) }

  include_context "with common transaction setup"

  let(:authorize_transaction) { create(:authorize_transaction, :approved, merchant:) }
  let!(:referenced_transaction) do
    create(:charge_transaction, :approved, merchant:, referenced_transaction: authorize_transaction)
  end
  let(:referenced_transaction_id) { referenced_transaction.id }
  let(:result) { subject }

  context "when new transaction is valid" do
    it_behaves_like "new transaction creation", Transactions::RefundTransaction
    it_behaves_like "status setting based on referenced transaction status"

    context "for referenced transaction status" do
      it "changes referenced transaction status to 'refunded'" do
        expect { service_call }.to change { referenced_transaction.reload.status }.from("approved").to("refunded")
      end
    end
  end

  context "when new transaction is invalid" do
    it_behaves_like "merchant validation"
    it_behaves_like "referenced transaction validation"
    it_behaves_like "transaction required amount validation"
    it_behaves_like "transaction required fields validation"

    context "for referenced transaction status" do
      let(:customer_email) { "" }

      it "does not change referenced transaction status to 'refunded'" do
        expect { service_call }.to not_change(referenced_transaction.reload, :status)
      end
    end
  end
end
