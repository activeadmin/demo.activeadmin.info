release: DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:schema:load db:seed
web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
