#!/bin/zsh -xe
# for production deploy

echo "#### kill older server"
PID=`ps ax | grep '[p]uma' | awk '{ print $1 }'`
if [ PID != "" ]; then
  echo "older server is ${PID}"
  kill -9 ${PID}
fi

echo "##### start server"
RAILS_ENV=production bundle exec rails s
