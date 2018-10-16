# Contains the base behavior of a registry - enumerable collection of
# keyed items
class Registry
  include Enumerable

  def initialize
    @collection = []
  end

  def [](index)
    @collection[index]
  end

  def each(&block)
    @collection.each(&block)
  end

  def empty?
    @collection.empty?
  end

  def length
    @collection.length
  end

  def delete_at(index)
    @collection.delete_at(index)
  end

  def add(item)
    @collection.push(item)
  end

  private

  def next_id
    if empty?
      0
    else
      last_item = max(&:id)
      last_item.id + 1
    end
  end

  def ensure_id!(hash)
    hash['id'] = next_id unless hash.key?('id')
    hash
  end
end
