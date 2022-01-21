# To run in the terminal type
# rake deploy:github["commit message"]
# rake deploy:heroku["commit message"]
# heroku apps
#--app cryptic-ridge-73996
#--app error-master-demo

namespace :deploy do
  desc 'Push to Github'
  task github: :environment, [:message] do |_t, parameter|
    system 'git add -A'
    system "git commit -m \"#{parameter[:message]}\""
    system 'git push'
  end

  desc 'Deploy to Heroku'
  task heroku: :environment, [:message] do |_t, parameter|
    system 'git add -A'
    system "git commit -m \"#{parameter[:message]}\""
    system 'git push'
    system 'git push heroku main'
  end
end
