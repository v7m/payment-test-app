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
