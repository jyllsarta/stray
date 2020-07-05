# qiitaからもらってきたかんたんapplyタスク
# https://qiita.com/lhside/items/0dcad79d9b801e34bc7c

namespace :db do

  desc 'Export database schema'
  task reset_test: :environment do
    puts "drop db..."
    `RAILS_ENV=test bundle exec rails db:drop`
    puts "create db..."
    `RAILS_ENV=test bundle exec rails db:create`
    puts "migrate db..."
    `RAILS_ENV=test bundle exec rails db:ridgepole:apply`
  end

  namespace :ridgepole do
    desc 'Apply database schema'
    task apply: :environment do
      ridgepole('--apply', "--file #{schema_file}")
      Rake::Task['db:schema:dump'].invoke
    end

    desc 'Export database schema'
    task export: :environment do
      ridgepole('--export', "--output #{schema_file}")
    end

    private

    def schema_file
      Rails.root.join('db/Schemafile')
    end

    def config_file
      Rails.root.join('config/database.yml')
    end

    def ridgepole(*options)
      command = ["bundle exec ridgepole", "--config #{config_file}"]
      command += ["-E production"] if Rails.env.production?
      command += ["-E test"] if Rails.env.test?
      system [command + options].join(' ')
    end
  end
end
