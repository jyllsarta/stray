#!/bin/zsh
# for update

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

