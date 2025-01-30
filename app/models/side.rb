class Side
  attr_accessor :id, :name, :price

  @@sides = []
  @@next_id = 1

  def initialize(attributes = {})
    @id = @@next_id
    @name = attributes[:name]
    @price = attributes[:price]
    @@next_id += 1
  end

  def self.create(attributes)
    side = new(attributes)
    if side.valid?
      @@sides << side
      side
    else
      false
    end
  end

  def self.all
    @@sides
  end

  def self.find(id)
    @@sides.find { |side| side.id == id.to_i }
  end

  def valid?
    !name.nil? && !price.nil?
  end
end