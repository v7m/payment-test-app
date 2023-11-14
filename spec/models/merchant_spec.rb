require 'rails_helper'

describe Merchant, type: :model do
  context "associations" do
    it { is_expected.to have_many(:transactions) }
    it { is_expected.to have_many(:authorize_transactions).class_name("Transactions::AuthorizeTransaction") }
    it { is_expected.to have_many(:charge_transactions).class_name("Transactions::ChargeTransaction") }
    it { is_expected.to have_many(:refund_transactions).class_name("Transactions::RefundTransaction") }
    it { is_expected.to have_many(:reversal_transactions).class_name("Transactions::ReversalTransaction") }
  end

  context "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to define_enum_for(:status).with_values(inactive: 0, active: 1) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to validate_email_format_of(:email) }
  end
end
