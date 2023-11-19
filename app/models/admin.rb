# frozen_string_literal: true

class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email_format: true
end
