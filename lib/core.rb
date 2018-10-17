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
    loop { main_menu }
  end

  private

  def main_menu
    choice = Input.read_choice("\nChoose an action",
                               [
                                 'Add a position', 'Add a person',
                                 'Remove a position', 'Remove a person',
                                 'Employ a person', 'List employees by name',
                                 'List employees by position',
                                 'List vacancies', 'Print salary statement',
                                 'Exit'
                               ])
    activate_choice(choice)
  end

  def activate_choice(choice)
    case choice
    when 0 then add_position
    when 1 then add_person
    when 2 then remove_position
    when 3 then remove_person
    when 4 then employ_person
    when 5 then list_employees(:employee)
    when 6 then list_employees(:position)
    when 7 then list_vacancies
    when 8 then print_statement
    when 9 then finish
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

  def list_employees(sort_by)
    puts 'List of employees:'
    puts @db.generate_employee_list(sort_by)
  end

  def list_vacancies
    puts 'List of vacancies:'
    @db.vacancies.each_with_index do |data, index|
      puts "#{index + 1}) #{data[:vacancy]} - #{data[:ammount]} available"
    end
  end

  def print_statement
    puts "Total salary expenses: $#{@db.total_salary}"
    DAO.write_file('data/statement.txt', @db.salary_report)
    puts 'Complete statement is saved to data/statement.txt'
  end

  def finish
    choice = Input.read_choice('Save changes?', %w[Yes No])
    DAO.write_db(@db) if choice.zero?
    exit
  end
end
