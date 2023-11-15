require "rails_helper"

describe Transactions::RefundTransaction, type: :model do
  context "associations" do
    it { is_expected.to belong_to(:charge_transaction) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:amount) }
  end
end
