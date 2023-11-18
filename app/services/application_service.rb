# frozen_string_literal: true

class ApplicationService
  RESULT_STATUS = {
    success: :success,
    failure: :failure
  }.freeze

  def self.call(**args, &block)
    new(**args, &block).call
  end

  def initialize
    @errors = []
    @record = nil
  end

  private

  def result_data
    OpenStruct.new(result_status:, errors: @errors, record: @record)
  end

  def result_status
    @errors.none? ? RESULT_STATUS[:success] : RESULT_STATUS[:failure]
  end
end
