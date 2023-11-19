# frozen_string_literal: true

class Admin < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email_format: true
end
