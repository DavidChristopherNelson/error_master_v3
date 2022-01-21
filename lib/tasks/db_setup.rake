# To run in the terminal type
# rake db_setup:reset
# rake db_setup:heroku_reset
# heroku apps
#--app cryptic-ridge-73996
#--app error-master-demo

namespace :db_setup do
  desc 'Reset, migrate and reseed the database.'
  task reset: :environment do
    system 'rails db:migrate:reset'
    system 'rails db:seed'
  end

  desc 'Reset, migrate and reseed the deployed app'
  task heroku_reset: :environment do
    system 'heroku pg:reset DATABASE_URL --app polar-refuge-71806'
    system 'heroku run rake db:migrate --app polar-refuge-71806'
    system 'heroku run rake db:seed --app polar-refuge-71806'
  end
end
