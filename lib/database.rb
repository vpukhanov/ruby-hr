require_relative 'people_registry'
require_relative 'positions_registry'

# Database is a layer between core of the application and data registries,
# provides additional helper methods to filter and sort their data
class Database
  def initialize(people_registry, positions_registry)
    @people_registry = people_registry
    @positions_registry = positions_registry
  end

  def self.from_yaml(yaml)
    Database.new(
      PeopleRegistry.from_yaml(yaml),
      PositionsRegistry.from_yaml(yaml)
    )
  end

  def positions
    @positions_registry
  end

  def positions_for_person(unemployed_index)
    person = unemployed_people[unemployed_index]
    @positions_registry.available_positions(person)
  end

  def employ_person(per_unemployed_index, pos_available_index)
    person = unemployed_people[per_unemployed_index]
    position = positions_for_person(per_unemployed_index)[pos_available_index]

    person.employ!(position.id)
    position.remove_vacancy!
  end

  def people
    @people_registry
  end

  def unemployed_people
    @people_registry.unemployed_people
  end

  def add_position(yaml)
    @positions_registry.add_position_from_yaml(yaml)
  end

  def add_person(yaml)
    @people_registry.add_person_from_yaml(yaml)
  end

  def remove_position(index)
    position = @positions_registry[index]
    @positions_registry.delete_at(index)
    @people_registry.unemploy_position(position.id)
  end

  def remove_person(index)
    person = @people_registry[index]
    @people_registry.delete_at(index)
    @positions_registry.add_vacancy(person.position_id) if person.position_id
  end
end
