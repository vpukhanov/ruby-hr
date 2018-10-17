require_relative 'requirement'

# Data-class that holds information about a single Position from a database.
# Contains helper methods for changing vacancy status and checking availability
class Position
  attr_reader :id, :name, :department, :salary, :vacancies, :requirements

  def initialize(id, name, department, salary, vacancies, requirements)
    @id = id
    @name = name
    @department = department
    @salary = salary
    @vacancies = vacancies
    @requirements = requirements
  end

  def self.from_yaml(yaml)
    Position.new(
      yaml['id'],
      yaml['name'], yaml['department'], yaml['salary'], yaml['vacancies'],
      Requirement.from_yaml(yaml['requirements'])
    )
  end

  def add_vacancy!
    @vacancies += 1
  end

  def remove_vacancy!
    @vacancies -= 1
  end

  def available_for?(person)
    @vacancies > 0 && @requirements.satisfied?(person)
  end

  def to_s
    "#{@name} at #{@department} for $#{@salary}"
  end
end
