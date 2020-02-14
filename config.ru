require './config/environment'

if ActiveRecord::Migration.check_pending!
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

use Rack::MethodOverride
use ProducersController
run ApplicationController
