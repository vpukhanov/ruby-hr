# Data-class that holds information about a single Person from a database.
# Contains helper methods for employment, unemployment and determining status
class Person
  attr_reader :id, :first_name, :second_name, :middle_name,
              :age, :education, :speciality, :position_id

  def initialize(options)
    @id = options['id']
    @first_name = options['first_name']
    @second_name = options['second_name']
    @middle_name = options['middle_name']
    @age = options['age']
    @education = options['education']
    @speciality = options['speciality']
    @position_id = options['position_id']
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

  def full_name
    if @middle_name
      "#{@first_name} #{@middle_name} #{@second_name}"
    else
      "#{@first_name} #{@second_name}"
    end
  end

  private

  def education_with_specialization
    edu_spec = ''
    edu_spec += "#{@education} education" if @education
    edu_spec += " specialized at #{@speciality}" if @speciality
    edu_spec
  end
end
