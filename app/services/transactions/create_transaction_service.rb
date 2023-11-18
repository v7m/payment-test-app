# frozen_string_literal: true

class Transactions::CreateTransactionService < ApplicationService
  attr_reader :initialized_transaction, :transaction_valid

  def initialize(merchant_id:, referenced_transaction_id: nil, status:, amount: nil, customer_email:, customer_phone: nil)
    validate_merchant_id!(merchant_id)
    validate_referenced_transaction_id_param!(referenced_transaction_id)
    validate_amount!(amount)

    @merchant_id = merchant_id
    @referenced_transaction_id = referenced_transaction_id
    @status = status
    @amount = amount
    @customer_email = customer_email
    @customer_phone = customer_phone
    super()
  end

  def call
    ActiveRecord::Base.transaction do
      initialize_transaction

      return result_data if initialized_transaction.blank?

      validate

      return result_data unless transaction_valid?

      yield if block_given?

      save_transaction
      result_data
    end
  end

  private

  def validate
    if initialized_transaction.valid?
      @transaction_valid = true
    else
      @transaction_valid = false
      @errors.concat(initialized_transaction.errors.full_messages)
    end
  end

  def save_transaction
    initialized_transaction.save!
    @record = initialized_transaction
  rescue ActiveRecord::RecordInvalid => e
    @errors.concat(e.record.errors.full_messages)
  end

  def initialize_transaction # rubocop:disable Metrics/MethodLength
    @initialized_transaction ||= Transaction.new(
      merchant_id: @merchant_id,
      referenced_transaction_id: referenced_transaction&.id,
      type: transaction_type,
      status: valid_transaction_status,
      amount: @amount,
      customer_email: @customer_email,
      customer_phone: @customer_phone
    )
  rescue ActiveRecord::RecordNotFound, ActiveRecord::AssociationTypeMismatch, ArgumentError => e
    @errors << e.message
  end

  def transaction_type
    raise NotImplementedError
  end

  def referenced_transaction
    @referenced_transaction ||= Transaction.find(@referenced_transaction_id)
  end

  def referenced_transaction_status_permitted?
    referenced_transaction.status.in?(Transaction::PERMITTED_REFERENCE_STATUSES)
  end

  def valid_transaction_status
    @valid_transaction_status ||= referenced_transaction_status_permitted? ? @status : "error"
  end

  def transaction_valid?
    @transaction_valid
  end

  def validate_merchant_id!(merchant_id)
    return if merchant_id.present?

    raise ArgumentError, "merchant_id is required"
  end

  def validate_referenced_transaction_id_param!(referenced_transaction_id)
    return if referenced_transaction_id.present?

    raise ArgumentError, "referenced_transaction_id is required"
  end

  def validate_amount!(amount)
    return if amount.present?

    raise ArgumentError, "amount is required"
  end
end
