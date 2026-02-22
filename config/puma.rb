threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "production" }

workers ENV.fetch("WEB_CONCURRENCY") { 2 }
preload_app!

plugin :tmp_restart
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Disconnect ActiveRecord before forking workers
before_fork do
  ActiveRecord::Base.connection_pool.disconnect! if defined?(ActiveRecord)
end

# Re-establish ActiveRecord connection after worker boots
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end