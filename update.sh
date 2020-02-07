# for update

git pull
bundle install
yarn install --check-files
bundle exec rails db:ridgepole:apply
bundle exec rails db:seed
