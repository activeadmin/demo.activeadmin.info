desc "CRON job for Heroku"
task :cron => ['db:schema:load', 'db:seed']
