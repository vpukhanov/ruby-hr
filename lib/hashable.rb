# Allows object to be converted to plain hashes, which contain all
# of the object's instance variables, for easier conversion to YAML
# without type-hints
module Hashable
  def to_hash
    instance_variables.each_with_object({}) do |var, hash|
      hash[var.to_s.delete('@')] = instance_variable_get(var)
    end
  end

  def encode_with(coder)
    coder.represent_object(nil, to_hash)
  end
end
