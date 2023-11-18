# frozen_string_literal: true

require "rails_helper"
require "models/concerns/referenced_transaction_merchant_validatable_spec"

describe Transactions::RefundTransaction, type: :model do
  context "for associations" do
    it { is_expected.to belong_to(:referenced_transaction).class_name("Transactions::ChargeTransaction") }
  end

  context "for validations" do
    it_behaves_like "referenced transaction merchant validatable"

    it { is_expected.to validate_presence_of(:amount) }
  end
end
