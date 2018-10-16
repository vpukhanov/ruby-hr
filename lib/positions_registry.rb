require_relative 'registry'
require_relative 'position'

# Holds the collection of positions in the database and provides helper methods
class PositionsRegistry < Registry
  def self.from_yaml(yaml)
    registry = PositionsRegistry.new
    yaml['positions'].each { |p| registry.add(Position.from_yaml(p)) }
    registry
  end

  def add_position_from_yaml(yaml)
    ensure_id!(yaml)
    add(Position.from_yaml(yaml))
  end

  def add_vacancy(id)
    position = find { |p| p.id == id }
    position.add_vacancy! if position
  end

  def available_positions(person)
    find_all { |p| p.available_for?(person) }
  end
end
