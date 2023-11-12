require 'rails_helper'

describe Merchant, type: :model do
  it { should validate_presence_of(:name) }
  it { should define_enum_for(:status).with_values(inactive: 0, active: 1) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
end