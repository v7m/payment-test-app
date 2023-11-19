# frozen_string_literal: true

require "rails_helper"
require "faker"
require "shared_examples/create_transaction_shared_examples"
require "shared_examples/transaction_shared_context"

describe Transactions::CreateAuthorizeTransactionService do
  subject(:service_call) { described_class.call(**transaction_params) }

  include_context "with common transaction setup"

  let(:referenced_transaction_id) { nil }
  let(:result) { subject }

  context "when new transaction is valid" do
    it_behaves_like "new transaction creation", Transactions::AuthorizeTransaction
  end

  context "when new transaction is invalid" do
    it_behaves_like "merchant validation"
    it_behaves_like "transaction required amount validation"
    it_behaves_like "transaction required fields validation"

    context "when referenced transaction exists" do
      let(:referenced_transaction) { create(:authorize_transaction, merchant:) }
      let(:referenced_transaction_id) { referenced_transaction.id }

      it "raises ArgumentError" do
        error_message = "referenced_transaction_id is not allowed for AuthorizeTransaction"

        expect { service_call }.to raise_error(ArgumentError, error_message)
      end
    end
  end
end
