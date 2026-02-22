# Puma configuration for production (Render)
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
threads threads_count, threads_count

# Port and environment
port        ENV.fetch("PORT") { 3000 }
environment ENV.fetch("RAILS_ENV") { "production" }

# Workers for clustered mode
workers ENV.fetch("WEB_CONCURRENCY") { 2 }  # Render supports multiple workers

# Preload the app for faster worker boot
preload_app!

# Allow puma to be restarted by `bin/rails restart`
plugin :tmp_restart

# Optional: Solid Queue supervisor in Puma
plugin :solid_queue if ENV["SOLID_QUEUE_IN_PUMA"]

# PID file (optional)
pidfile ENV["PIDFILE"] if ENV["PIDFILE"]

# Worker boot hook — ensures DB connection is established for each worker
on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end