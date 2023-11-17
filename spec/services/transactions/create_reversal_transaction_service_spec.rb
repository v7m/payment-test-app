require "rails_helper"
require 'faker'
require 'shared_examples/create_transaction_shared_examples'

describe Transactions::CreateReversalTransactionService do
  subject { described_class.call(**transaction_params) }

  include_context "with common transaction setup"

  let(:referenced_transaction) { create(:authorize_transaction, :approved, merchant: merchant) }
  let(:referenced_transaction_id) { referenced_transaction.id }
  let(:amount) { nil }
  let(:result) { subject }

  context "when new transaction is valid" do
    it_behaves_like "new transaction creation", Transactions::ReversalTransaction
    it_behaves_like "status setting based on referenced transaction status"

    context "referenced transaction status" do
      it "changes referenced transaction status to 'reversal'" do
        expect { subject }.to change { referenced_transaction.reload.status }.from("approved").to("reversed")
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
        expect { subject }.to raise_error(ArgumentError, "amount is not allowed for ReversalTransaction")
      end
    end

    context "referenced transaction status" do
      let(:customer_email) { "" }

      it "does not change referenced transaction status to 'reversal'" do
        expect { subject }.to not_change { referenced_transaction.reload.status }
      end
    end
  end
end
