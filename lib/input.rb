# Input module provides access to helper methods that allow for easier
# user input processing. Includes methods for reading custom types
# like Person and Position
module Input
  def self.read_with_predicate(prompt)
    loop do
      print "#{prompt}> "
      input = gets
      return input if input && yield(input)
    end
  end

  def self.read_string(prompt, allow_empty = false)
    result = (read_with_predicate(prompt) do |input|
      valid = allow_empty || !input.strip.empty?
      puts 'String should have non-space characters' unless valid
      valid
    end).strip!
    return nil if result.empty?

    result
  end

  def self.read_positive_int(prompt)
    (read_with_predicate(prompt) do |input|
      int = input.to_i
      valid = int > 0
      puts 'Expecting a positive integer number' unless valid
      valid
    end).to_i
  end

  def self.read_salary
    (read_with_predicate('Enter salary') do |input|
      salary = input.to_f
      valid = salary > 0
      puts 'Salary is a float number greater than 0' unless valid
      valid
    end).to_f
  end

  def self.read_number_between(prompt, min, max)
    (read_with_predicate(prompt) do |input|
      num = input.to_i
      valid = num.between?(min, max)
      puts "Choose a number from #{min} to #{max}" unless valid
      valid
    end).to_i
  end

  def self.read_choice(prompt, choices)
    puts "#{prompt}:"

    if choices.empty?
      puts 'No choice to make'
      return nil
    end

    choices.each_with_index { |c, i| puts "#{i + 1}) #{c}" }

    # return an actual array index of the selected choice
    read_number_between('Choice', 1, choices.length) - 1
  end

  def self.read_education(prompt)
    available = %w[higher secondary elementary none]
    selected = available[Input.read_choice(prompt, available)]
    if selected == 'none'
      nil
    else
      selected
    end
  end

  def self.read_requirements
    puts "\nEnter position requirements:"
    requirements = {
      'age' => read_positive_int('Minimum age'),
      'education' => read_education('Minimum education'),
      'speciality' => read_string('Required speciality (can be empty)', true)
    }
    requirements['education'] = nil if requirements['education'] == 'none'
    requirements
  end

  def self.read_position
    puts "\nCreating a new position:"
    {
      'name' => read_string('Name'),
      'department' => read_string('Department'),
      'salary' => read_salary,
      'vacancies' => read_positive_int('Open vacancies'),
      'requirements' => read_requirements
    }
  end

  def self.read_person
    puts "\nAdding a new person:"
    {
      'first_name' => read_string('First name'),
      'second_name' => read_string('Second name'),
      'middle_name' => read_string('Middle name (can be empty)', true),
      'age' => read_positive_int('Age'),
      'education' => read_education('Education'),
      'speciality' => read_string('Speciality (can be empty)', true)
    }
  end
end
