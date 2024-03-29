require_relative 'registry'
require_relative 'position'

# Holds the collection of positions in the database and provides helper methods
class PositionsRegistry < Registry
  def initialize(yaml)
    super()
    yaml['positions'].each { |p| add(Position.new(p)) }
  end

  def add_position_from_yaml(yaml)
    ensure_id!(yaml)
    add(Position.new(yaml))
  end

  def add_vacancy(id)
    position = find { |p| p.id == id }
    position.add_vacancy! if position
  end

  def available_positions(person)
    find_all { |p| p.available_for?(person) }
  end

  def find_by_id(id)
    find { |p| p.id == id }
  end

  def vacancies
    find_all { |p| p.vacancies > 0 }
  end
end
