# frozen_string_literal: true

env :GEM_PATH, "/usr/local/bundle"
set :environment, ENV["RAILS_ENV"]
set :output, "/var/log/cron_log.log"
ENV.each { |k, v| env(k, v) }

every 1.minute do
  rake "delete_old_transactions:run"
end
