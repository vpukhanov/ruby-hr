require_relative 'dao'
require_relative 'input'

# Main class of the application, interactive layer between the user
# and the database.
class Core
  def initialize
    @db = DAO.read_db
  end

  def run
    puts 'RubyCorp HR'
    puts "Manage RubyCorp's employees and positions\n"
    main_menu
  end

  private

  def main_menu
    loop do
      pp @db # DELET THIS
      choice = Input.read_choice('Choose an action',
                                 [
                                   'Add a position', 'Add a person',
                                   'Remove a position', 'Remove a person',
                                   'Employ a person'
                                 ])
      activate_choice(choice)
    end
  end

  def activate_choice(choice)
    case choice
    when 0 then add_position
    when 1 then add_person
    when 2 then remove_position
    when 3 then remove_person
    when 4 then employ_person
    end
  end

  def add_position
    @db.add_position(Input.read_position)
  end

  def add_person
    @db.add_person(Input.read_person)
  end

  def remove_position
    choice = Input.read_choice('Select position to remove', @db.positions)
    @db.remove_position(choice) if choice
  end

  def remove_person
    choice = Input.read_choice('Select person to remove', @db.people)
    @db.remove_person(choice) if choice
  end

  def employ_person
    c_person = Input.read_choice('Person to employ', @db.unemployed_people)
    return unless c_person

    c_position = Input.read_choice('Available positions',
                                   @db.positions_for_person(c_person))
    @db.employ_person(c_person, c_position) if c_position
  end
end
