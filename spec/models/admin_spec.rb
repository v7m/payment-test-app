# frozen_string_literal: true

require "rails_helper"

describe Admin, type: :model do
  context "for validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { is_expected.to validate_email_format_of(:email) }
  end
end
