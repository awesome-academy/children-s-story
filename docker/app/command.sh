if [ -f tmp/pids/server.pid ]; then
    rm tmp/pids/server.pid
fi

bundle check || bundle install

rake db:migrate

printenv | grep -v "no_proxy" >> /etc/environment

if [ "$RAILS_ENV" = "production" -o "$RAILS_ENV" = "staging" ]; then
    rake assets:precompile
    RAILS_ENV=$RAILS_ENV bundle exec puma -C config/puma.rb
else
    rake db:seed
    bundle exec rails s -b 0.0.0.0 -p $RAILS_PORT
fi