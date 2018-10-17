require_relative 'requirement'
require_relative 'hashable'

# Data-class that holds information about a single Position from a database.
# Contains helper methods for changing vacancy status and checking availability
class Position
  include Hashable

  attr_reader :id, :name, :department, :salary, :vacancies, :requirements

  def initialize(options)
    @id = options['id']
    @name = options['name']
    @department = options['department']
    @salary = options['salary']
    @vacancies = options['vacancies']
    @requirements = Requirement.new(options['requirements'])
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
