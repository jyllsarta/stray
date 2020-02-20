#!/bin/zsh
# for production deploy

echo "# update repository"
git pull

echo "# bundle install"
bundle install

echo "# yarn install"
yarn install --check-files

echo "# db migrate"
bundle exec rails db:ridgepole:apply

echo "# db seed"
bundle exec rails db:seed

echo "# precompile asset"
bundle exec rails assets:precompile

echo "# kill older server"
bundle exec rails db:seed

echo "kill older server"
PID=`ps ax | grep '[p]uma' | awk '{ print $1 }'`
echo "older server is ${PID}"
kill -9 ${PID}

echo "start server"
RAILS_ENV=production bundle exec rails s -d
