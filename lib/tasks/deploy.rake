# To run in the terminal type
# rake deploy:github["commit message"]
# rake deploy:heroku["commit message"]
# heroku apps
# --app cryptic-ridge-73996
# --app error-master-demo
# --app polar-refuge-71806

namespace :deploy do
  desc 'Push to Github'
  task :github, [:message] do |_t, parameter|
    system 'git add -A'
    system "git commit -m \"#{parameter[:message]}\""
    system 'git push'
  end

  desc 'Deploy to Heroku'
  task :heroku, [:message] do |_t, parameter|
    system 'git add -A'
    system "git commit -m \"#{parameter[:message]}\""
    system 'git push'
    system 'git push heroku main'
  end
end
