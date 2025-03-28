require "csv"
require_relative "../lib/spinner"

def seed_names_from_familieretshuset(filename)
  puts "\tSeeding names from #{filename.inspect}..."
  size = CSV.read(filename).length - 1
  names = []

  CSV.foreach(filename, headers: true).with_index do |row, index|
    gender = nil
    if row["Drengenavn"] == "Ja"
      gender = "male"
    end

    if row["Pigenavn"] == "Ja"
      gender = gender == "male" ? "unisex" : "female"
    end

    names << Name.new(name: row["Navn"], gender:)
    Spinner.spin(index+1, size)
  end

  Name.import(names, on_duplicate_key_ignore: true)
  puts "\n\n"
end

def seed_names_from_navneguiden(filename)
  puts "\tSeeding names from #{filename.inspect}..."
  size = CSV.read(filename).length - 1
  names = []

  CSV.foreach(filename, headers: true).with_index do |row, index|
    gender = "unisex"
    gender = "female" if row["gender"] == "0"
    gender = "male" if row["gender"] == "100"

    names << Name.new(name: row["name"], gender:)
    Spinner.spin(index+1, size)
  end

  Name.import(names, on_duplicate_key_ignore: true)
  puts "\n\n"
end

puts "Seeding users..."
puts "\tSeeding Nanna"
user = User.find_by(username: "nanna")
user ||= User.create!(username: "nanna", password: "secret")

puts "\tSeeding Emil"
user = User.find_by(username: "emil")
user ||= User.create!(username: "emil", password: "secret")
puts "Done seeding users!"

puts "Seeding names..."
# seed_names_from_familieretshuset("db/pige-navne.csv")
# seed_names_from_familieretshuset("db/drenge-navne.csv")
seed_names_from_navneguiden("db/seeds/navneguiden_boys.csv")
seed_names_from_navneguiden("db/seeds/navneguiden_girls.csv")
puts "Done seeding names!"
