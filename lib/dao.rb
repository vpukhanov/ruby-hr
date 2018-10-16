require 'yaml'

require_relative 'database'

# Data Access Object, gives an ability to read (and write) the database
# to and from the .yml data files
module DAO
  def self.read_db
    Database.from_yaml(YAML.safe_load(read_db_file))
  end

  def self.read_db_file
    if File.exist?('data/data.yml')
      db_file = File.new('data/data.yml')
      db_text = db_file.read
      db_file.close
      db_text
    else
      puts 'Could not read database file. Starting with an empty database'
      ''
    end
  end
end
