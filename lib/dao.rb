require 'yaml'

require_relative 'database'

# Data Access Object, gives an ability to read (and write) data
# from and to the files
module DAO
  DB_FILENAME = 'data/data.yml'.freeze

  def self.read_db
    Database.new(YAML.safe_load(read_db_file))
  end

  def self.write_db(db)
    File.rename(DB_FILENAME, DB_FILENAME + '.bak') if File.exist?(DB_FILENAME)
    write_file(DB_FILENAME, YAML.dump(db))
  end

  def self.read_db_file
    if File.exist?(DB_FILENAME)
      db_file = File.new(DB_FILENAME)
      db_text = db_file.read
      db_file.close
      db_text
    else
      puts 'Could not read database file. Starting with an empty database'
      ''
    end
  end

  def self.write_file(filename, data)
    File.write(filename, data)
  end
end
