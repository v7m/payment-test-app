# frozen_string_literal: true

require "rails_helper"

describe Transactions::AuthorizeTransaction, type: :model do
  context "for associations" do
    it { is_expected.to have_many(:charge_transactions) }
    it { is_expected.to have_many(:reversal_transactions) }
  end

  context "for validations" do
    it { is_expected.to validate_presence_of(:amount) }
  end
end
