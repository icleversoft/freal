require 'redis'
require 'icapnd'

Rails.logger.debug 'Setting up APNMachine...'
Icapnd::Config.redis = Redis.new(:host=>'127.0.0.1', :port=>6379)
Icapnd::Config.logger = Rails.logger