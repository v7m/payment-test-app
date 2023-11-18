# frozen_string_literal: true

class Transactions::AuthorizeTransaction < Transaction
  has_many :charge_transactions, foreign_key: :referenced_transaction_id,
                                 dependent: :destroy,
                                 inverse_of: :referenced_transaction
  has_many :reversal_transactions, foreign_key: :referenced_transaction_id,
                                   dependent: :destroy,
                                   inverse_of: :referenced_transaction

  validates :amount, presence: true
end
