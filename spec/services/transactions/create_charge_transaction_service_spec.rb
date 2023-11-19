# frozen_string_literal: true

require "rails_helper"
require "faker"
require "shared_examples/create_transaction_shared_examples"
require "shared_examples/transaction_shared_context"

describe Transactions::CreateChargeTransactionService do
  subject { described_class.call(**transaction_params) }

  include_context "with common transaction setup"

  let(:referenced_transaction) { create(:authorize_transaction, :approved, merchant:) }
  let(:referenced_transaction_id) { referenced_transaction.id }
  let(:result) { subject }

  context "when new transaction is valid" do
    it_behaves_like "new transaction creation", Transactions::ChargeTransaction
    it_behaves_like "status setting based on referenced transaction status"
  end

  context "when new transaction is invalid" do
    it_behaves_like "merchant validation"
    it_behaves_like "referenced transaction validation"
    it_behaves_like "transaction required amount validation"
    it_behaves_like "transaction required fields validation"
  end
end
