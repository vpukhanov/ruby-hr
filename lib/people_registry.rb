require_relative 'registry'
require_relative 'person'

# Holds the collection of people in the database and provides helper methods
class PeopleRegistry < Registry
  def initialize(yaml)
    super()
    yaml['people'].each { |p| add(Person.new(p)) }
  end

  def add_person_from_yaml(yaml)
    ensure_id!(yaml)
    add(Person.new(yaml))
  end

  def unemploy_position(position_id)
    each { |p| p.unemploy! if p.position_id == position_id }
  end

  def employed_people
    find_all { |p| !p.position_id.nil? }
  end

  def unemployed_people
    find_all { |p| p.position_id.nil? }
  end
end
