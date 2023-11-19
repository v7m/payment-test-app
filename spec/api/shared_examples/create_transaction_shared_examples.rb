# frozen_string_literal: true

shared_examples "create transaction endpoint" do
  context "with valid params" do
    specify "returns status 201" do
      expect(response).to have_http_status(:created)
    end

    specify "returns correct JSON" do
      json_response = JSON.parse(response.body)

      expect(json_response["merchant_id"]).to eq(merchant_id)
      expect(json_response["referenced_transaction_id"]).to eq(referenced_transaction_id)
      expect(json_response["status"]).to eq(status)
      expect(json_response["amount"]).to eq(amount.to_f)
      expect(json_response["customer_phone"]).to eq(customer_phone)
      expect(json_response["customer_email"]).to eq(customer_email)
    end
  end

  context "with invalid params" do
    context "with invalid status" do
      let(:status) { "not_valid_status" }

      specify "returns status 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      specify "returns correct JSON" do
        json_response = JSON.parse(response.body)

        expect(json_response["errors"]).to include("'not_valid_status' is not a valid status")
      end
    end

    context "when merchant is inactive" do
      let(:merchant) { create(:merchant, :inactive) }

      specify "returns status 422" do
        expect(response).to have_http_status(:unprocessable_entity)
      end

      specify "returns correct JSON" do
        json_response = JSON.parse(response.body)

        expect(json_response["errors"]).to include("Merchant is in inactive state")
      end
    end
  end
end
