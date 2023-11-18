require "rails_helper"

shared_examples "referenced transaction merchant validatable" do
  let(:transaction_factory_name) { described_class.name.demodulize.underscore.to_sym }
  let!(:merchant1) { create(:merchant, :active) }
  let!(:referenced_transaction) do
    if described_class.name == "Transactions::RefundTransaction"
      create(:charge_transaction_with_referenced, :approved, merchant: merchant1)
    else
      create(:authorize_transaction, :approved, merchant: merchant1)
    end
  end

  describe "#referenced_transaction_merchant" do
    context "when a transaction has the same merchant as the referenced transaction" do
      let(:transaction) do 
        build(transaction_factory_name, :approved, merchant: merchant1, referenced_transaction: referenced_transaction)
      end

      it "does not add any error messages on validation" do
        transaction.valid?

        expect(transaction.errors.full_messages).to be_empty
      end
    end
    
    context "when a transaction has a different merchant as the reference transaction" do
      let!(:merchant2) { create(:merchant, :active) }
      let(:transaction) do 
        build(transaction_factory_name, :approved, merchant: merchant2, referenced_transaction: referenced_transaction)
      end

      it "does not add error message on validation" do
        error_message = "Merchant Merchant mismatch between referenced and current transactions"
        transaction.valid?

        expect(transaction.errors.full_messages).to include(error_message)
      end
    end
  end
end
