# frozen_string_literal: true

require "rails_helper"
require "api/shared_examples/create_transaction_shared_examples"
require "shared_examples/transaction_shared_context"

describe PaymentAPI::V1::Transactions::AuthorizeTransactions, type: :request do
  include_context "with common transaction setup"

  let(:referenced_transaction_id) { nil }
  let(:transaction_params) do
    {
      merchant_id:,
      status:,
      amount:,
      customer_email:,
      customer_phone:
    }
  end

  describe "POST /api/v1/authorize_transactions" do
    before do
      post "/api/v1/authorize_transactions", params: transaction_params
    end

    it_behaves_like "create transaction endpoint"
  end
end
