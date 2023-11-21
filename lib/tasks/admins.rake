# frozen_string_literal: true

require "csv"

namespace :admins do
  desc "Create admins from CSV"
  task :create_from_csv, [:file_name] => :environment do |_task, args|
    puts args[:file_name]
    file_path = "csv/#{args[:file_name]}"

    CSV.foreach(file_path, encoding: "bom|utf-8", headers: true, col_sep: ",") do |row|
      allowed_fields = %w[name email]
      params = row.to_h.slice(*allowed_fields)
      params.merge!(password: "password123")

      admin = Admin.new(params.merge(password: "password123"))

      if admin.save
        puts "Admin created: #{row['name']}"
      else
        puts "Admin error: #{admin.errors.full_messages}"
      end
    end
  end
end
