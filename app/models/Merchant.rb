class Merchant < ApplicationRecord
  enum status: { inactive: 0, active: 1 }

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: statuses.values }
  validates :email, presence: true, uniqueness: true, email: true
end
