desc "CRON job for Heroku"
task :cron => ['db:seed']
