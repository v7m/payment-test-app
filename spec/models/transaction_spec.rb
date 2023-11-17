require "rails_helper"

describe Transaction, type: :model do
  context "associations" do
    it { is_expected.to belong_to(:merchant) }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:type) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0).allow_nil }
    it { is_expected.to define_enum_for(:status).with_values(approved: 0, reversed: 1, refunded: 2, error: 3) }
    it { is_expected.to validate_presence_of(:customer_email) }
    it { is_expected.to validate_email_format_of(:customer_email) }
  end
end
