# frozen_string_literal: true

namespace :delete_old_transactions do
  desc "Delete transactions created more than 1 hour ago"
  task run: :environment do
    threshold_time = 1.hour.ago
    old_transactions = Transaction.where("created_at <= ?", threshold_time)

    if old_transactions.any?
      old_transactions.destroy_all
      puts "#{old_transactions.count} transactions deleted."
    else
      puts "No old transactions found."
    end
  end
end
