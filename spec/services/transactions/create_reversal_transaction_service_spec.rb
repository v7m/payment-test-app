# frozen_string_literal: true

require "rails_helper"
require "faker"
require "shared_examples/create_transaction_shared_examples"
require "shared_examples/transaction_shared_context"

describe Transactions::CreateReversalTransactionService do
  subject(:service_call) { described_class.call(**transaction_params) }

  include_context "with common transaction setup"

  let(:referenced_transaction) { create(:authorize_transaction, :approved, merchant:) }
  let(:referenced_transaction_id) { referenced_transaction.id }
  let(:amount) { nil }
  let(:result) { subject }

  context "when new transaction is valid" do
    it_behaves_like "new transaction creation", Transactions::ReversalTransaction
    it_behaves_like "status setting based on referenced transaction status"

    context "for referenced transaction status" do
      it "changes referenced transaction status to 'reversal'" do
        expect { service_call }.to change { referenced_transaction.reload.status }.from("approved").to("reversed")
      end
    end
  end

  context "when new transaction is invalid" do
    it_behaves_like "merchant validation"
    it_behaves_like "referenced transaction validation"
    it_behaves_like "transaction required fields validation"

    context "when amount is present" do
      let(:amount) { 100 }

      it "raises ArgumentError" do
        expect { service_call }.to raise_error(ArgumentError, "amount is not allowed for ReversalTransaction")
      end
    end

    context "for referenced transaction status" do
      let(:customer_email) { "" }

      it "does not change referenced transaction status to 'reversal'" do
        expect { service_call }.to not_change(referenced_transaction.reload, :status)
      end
    end
  end
end
