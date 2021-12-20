# To run in the terminal type
# rake db_setup:reset
# rake db_setup:heroku_reset
# heroku apps
#--app cryptic-ridge-73996
#--app error-master-demo

namespace :db_setup do
  desc 'Reset, migrate and reseed the database.'
  task :reset do
    system 'rails db:migrate:reset'
    system 'rails db:seed'
  end

  desc 'Reset, migrate and reseed the deployed app'
  task :heroku_reset do
    system 'heroku pg:reset DATABASE_URL --app cryptic-ridge-73996'
    system 'heroku run rake db:migrate --app cryptic-ridge-73996'
    system 'heroku run rake db:seed --app cryptic-ridge-73996'
  end
end
