# frozen_string_literal: true

shared_context "with common transaction setup" do
  let!(:merchant) { create(:merchant, :active) }
  let(:merchant_id) { merchant.id }
  let(:status) { "approved" }
  let(:amount) { 100.0 }
  let(:customer_phone) { Faker::PhoneNumber.phone_number }
  let(:customer_email) { Faker::Internet.email }
  let(:transaction_params) do
    {
      merchant_id:,
      referenced_transaction_id:,
      status:,
      amount:,
      customer_email:,
      customer_phone:
    }
  end
end

shared_examples "new transaction creation" do |klass|
  it "returns correct data" do
    expect(result.result_status).to eq(:success)
    expect(result.record).to be_an_instance_of(klass)
    expect(result.errors).to be_empty
  end

  it "creates new #{klass.name}" do
    expect { subject }.to change(klass, :count).by(1)
  end
end

shared_examples "merchant validation" do
  context "when merchant_id is nil" do
    let(:merchant_id) { nil }

    it "raises ArgumentError" do
      expect { subject }.to raise_error(ArgumentError, "merchant_id is required")
    end
  end

  context "when merchant is not exists" do
    let(:merchant_id) { 99 }

    it "returns correct data" do
      expect(result.result_status).to eq(:failure)
      expect(result.record).to be_nil
      expect(result.errors).to include("Merchant must exist")
    end
  end
end

shared_examples "transaction required amount validation" do
  context "when amount is not present" do
    let(:amount) { nil }

    it "raises ArgumentError" do
      expect { subject }.to raise_error(ArgumentError, "amount is required")
    end
  end

  context "when amount is invalid" do
    let(:amount) { -100.0 }

    it "returns correct data" do
      expect(result.result_status).to eq(:failure)
      expect(result.record).to be_nil
      expect(result.errors).to include("Amount must be greater than 0")
    end
  end
end

shared_examples "transaction required fields validation" do
  context "when status is invalid" do
    let(:status) { "invalid_status" }

    it "returns correct data" do
      expect(result.result_status).to eq(:failure)
      expect(result.record).to be_nil
      expect(result.errors).to include("'invalid_status' is not a valid status")
    end
  end

  context "when customer_email is invalid" do
    let(:customer_email) { "" }

    it "returns correct data" do
      expect(result.result_status).to eq(:failure)
      expect(result.record).to be_nil
      expect(result.errors).to include(
        "Customer email can't be blank", 
        "Customer email does not appear to be a valid e-mail address"
      )
    end
  end
end

shared_examples "status setting based on referenced transaction status" do
  shared_examples "with correct status" do |status|
    before do
      referenced_transaction.update!(status:)
    end

    it "returns correct data" do
      expect(result.result_status).to eq(:success)
      expect(result.record.status).to eq(status)
    end
  end

  context "when referenced transaction status are permitted" do
    %w[approved refunded].each do
      it_behaves_like "with correct status", "approved"
    end
  end

  context "when referenced transaction status not permitted" do
    %w[reversed error].each do
      it_behaves_like "with correct status", "error"
    end
  end
end

shared_examples "referenced transaction validation" do
  context "when referenced referenced_transaction_id is nil" do
    let(:referenced_transaction_id) { nil }

    it "raises ArgumentError" do
      error_message = "referenced_transaction_id is required"

      expect { subject }.to raise_error(ArgumentError, error_message)
    end
  end

  context "when referenced transaction is not exist" do
    let(:referenced_transaction_id) { 99_999 }

    it "returns correct data" do
      expect(result.result_status).to eq(:failure)
      expect(result.record).to be_nil
      expect(result.errors).to include("Couldn't find Transaction with 'id'=99999")
    end
  end

  context "when referenced transaction has wrong type" do
    let(:referenced_transaction) { create(:refund_transaction_with_referenced, :approved, merchant:) }

    it "returns correct data" do
      expect(result.result_status).to eq(:failure)
      expect(result.record).to be_nil
      expect(result.errors).to include("Referenced transaction must exist")
    end
  end
end
