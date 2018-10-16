# Data-class that holds information about a single Person from a database.
# Contains helper methods for employment, unemployment and determining status
class Person
  attr_reader :id, :age, :education, :speciality, :position_id

  def initialize(id,
                 first_name, second_name, middle_name,
                 age, education, speciality, position_id)
    @id = id
    @first_name = first_name
    @second_name = second_name
    @middle_name = middle_name
    @age = age
    @education = education
    @speciality = speciality
    @position_id = position_id
  end

  def self.from_yaml(yaml)
    Person.new(
      yaml['id'],
      yaml['first_name'], yaml['second_name'], yaml['middle_name'],
      yaml['age'], yaml['education'], yaml['speciality'], yaml['position_id']
    )
  end

  def employed?
    position_id != nil
  end

  def employ!(position_id)
    @position_id = position_id
  end

  def unemploy!
    @position_id = nil
  end

  def to_s
    edu_spec = education_with_specialization
    edu_spec = ', ' + edu_spec unless edu_spec.empty?
    "#{full_name}, #{@age} y.o.#{edu_spec}"
  end

  private

  def full_name
    if @middle_name
      "#{@first_name} #{@middle_name} #{@second_name}"
    else
      "#{@first_name} #{@second_name}"
    end
  end

  def education_with_specialization
    edu_spec = ''
    edu_spec += "#{@education} education" if @education
    edu_spec += " specialized at #{@speciality}" if @speciality
    edu_spec
  end
end
