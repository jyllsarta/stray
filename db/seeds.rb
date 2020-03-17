# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"

TABLES = [:items]

TABLES.map(&:to_s).each do |table_name|
  clazz = table_name.singularize.camelize.constantize
  clazz.delete_all
  accepted_attributes = clazz.new.attributes.keys.map(&:to_sym)
  records = []
  CSV.open("#{ENV['MASTERDATA_PATH']}/#{table_name}.csv", headers: true, header_converters: :symbol) do |csv|
    csv.each do |line|
      attributes = line.to_h.select{|k, _| k.in? accepted_attributes}
      records.push(clazz.new(attributes))
    end
  end
  clazz.import(records)
  puts "created #{clazz} (#{clazz.count})"
end

Dungeon.delete_all
Dungeon.create(id: 1, name: "翠海の輝浜", depth: 400)

puts "seeded!"