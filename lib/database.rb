require_relative 'people_registry'
require_relative 'positions_registry'
require_relative 'hashable'

# Database is a layer between core of the application and data registries,
# provides additional helper methods to filter and sort their data
class Database
  include Hashable

  attr_reader :people, :positions

  def initialize(yaml)
    @people = PeopleRegistry.new(yaml)
    @positions = PositionsRegistry.new(yaml)
  end

  def positions_for_person(unemployed_index)
    person = unemployed_people[unemployed_index]
    @positions.available_positions(person)
  end

  def employ_person(per_unemployed_index, pos_available_index)
    person = unemployed_people[per_unemployed_index]
    position = positions_for_person(per_unemployed_index)[pos_available_index]

    person.employ!(position.id)
    position.remove_vacancy!
  end

  def employees_with_positions(sort_field)
    pairs = @people.employed_people.map do |employee|
      {
        employee: employee,
        position: @positions.find_by_id(employee.position_id)
      }
    end
    case sort_field
    when :employee then pairs.sort_by { |pair| pair[:employee].full_name }
    else pairs.sort_by { |pair| pair[sort_field].name }
    end
  end

  def unemployed_people
    @people.unemployed_people
  end

  def vacancies
    @positions.vacancies.map do |position|
      {
        vacancy: position,
        ammount: position.vacancies
      }
    end
  end

  def total_salary
    @people.employed_people.sum do |employee|
      @positions.find_by_id(employee.position_id).salary
    end
  end

  def generate_employee_list(sort_method)
    list = ''
    employees_with_positions(sort_method).each_with_index do |pair, index|
      list += "#{index + 1}) #{pair[:employee]}\n   #{pair[:position]}\n"
    end
    list
  end

  def salary_report
    res = "Salary report:\n\nTotal salary: $#{total_salary}\n\n"
    res + generate_employee_list(:employee)
  end

  def add_position(yaml)
    @positions.add_position_from_yaml(yaml)
  end

  def add_person(yaml)
    @people.add_person_from_yaml(yaml)
  end

  def remove_position(index)
    position = @positions[index]
    @positions.delete_at(index)
    @people.unemploy_position(position.id)
  end

  def remove_person(index)
    person = @people[index]
    @people.delete_at(index)
    @positions.add_vacancy(person.position_id) if person.position_id
  end
end
