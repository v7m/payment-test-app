# frozen_string_literal: true

require "rails_helper"
require "api/shared_examples/create_transaction_shared_examples"
require "shared_examples/transaction_shared_context"

describe PaymentAPI::V1::Transactions::RefundTransactions, type: :request do
  include_context "with common transaction setup"

  let(:referenced_transaction) { create(:charge_transaction_with_referenced, :approved, merchant:) }
  let(:referenced_transaction_id) { referenced_transaction.id }

  describe "POST /api/v1/refund_transactions" do
    before do
      post "/api/v1/refund_transactions", params: transaction_params
    end

    it_behaves_like "create transaction endpoint"
  end
end
