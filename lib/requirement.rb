# Data-class that holds information about the requirements for the specific
# position. Contains helper methods to check if person satisfies the conditions
class Requirement
  def initialize(age, education, speciality)
    @age = age
    @education = education
    @speciality = speciality
  end

  def self.from_yaml(yaml)
    Requirement.new(yaml['age'], yaml['education'], yaml['speciality'])
  end

  def satisfied?(person)
    person.age > @age &&
      satisfies_education(person.education) &&
      satisfies_speciality(person.speciality)
  end

  def to_s
    res = "Older than #{@age}"
    res += ", has at least #{@education} education" if @education
    res += ", specializes at #{@speciality}" if @speciality
    res
  end

  private

  def satisfies_education(education)
    education_to_int(education) >= education_to_int(@education)
  end

  def satisfies_speciality(speciality)
    @speciality.nil? || @speciality == speciality
  end

  def education_to_int(education)
    case education
    when 'higher'
      3
    when 'secondary'
      2
    when 'elementary'
      1
    else
      0
    end
  end
end
