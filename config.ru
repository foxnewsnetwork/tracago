# This file is used by Rack-based servers to start the application.

# Supposedly enables this magic RGenGC that makes GC take sorter periods of time.
# We will see
if defined?(Unicorn::HttpRequest)
  require 'gctools/oobgc'
  use GC::OOB::UnicornMiddleware
end

require ::File.expand_path('../config/environment',  __FILE__)
run Rails.application
