require_relative 'registry'
require_relative 'person'

# Holds the collection of people in the database and provides helper methods
class PeopleRegistry < Registry
  def self.from_yaml(yaml)
    registry = PeopleRegistry.new
    yaml['people'].each { |p| registry.add(Person.from_yaml(p)) }
    registry
  end

  def add_person_from_yaml(yaml)
    ensure_id!(yaml)
    add(Person.from_yaml(yaml))
  end

  def unemploy_position(position_id)
    each { |p| p.unemploy! if p.position_id == position_id }
  end

  def unemployed_people
    find_all { |p| p.position_id.nil? }
  end
end
