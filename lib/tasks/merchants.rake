# frozen_string_literal: true

require "csv"

namespace :merchants do
  desc "Create merchnats from CSV"
  task :create_from_csv, [:file_name] => :environment do |_task, args|
    puts args[:file_name]
    file_path = "csv/#{args[:file_name]}"

    CSV.foreach(file_path, encoding: "bom|utf-8", headers: true, col_sep: ",") do |row|
      allowed_fields = %w[name status email]
      params = row.to_h.slice(*allowed_fields)
      params.merge!(password: "password123")

      merchant = Merchant.new(params)

      if merchant.save
        puts "Merchant created: #{row['name']}"
      else
        puts "Merchant error: #{merchant.errors.full_messages}"
      end
    end
  end
end
