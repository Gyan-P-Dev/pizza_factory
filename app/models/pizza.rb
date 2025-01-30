class Pizza
  attr_accessor :id, :name, :category, :base_price

  @@pizzas = []
  @@next_id = 1

  SIZES = { regular: 0, medium: 1, large: 2 }
  CRUSTS = { new_hand_tossed: 0, wheat_thin_crust: 1, cheese_burst: 2, fresh_pan_pizza: 3 }
  CATEGORIES = { vegetarian: 0, non_vegetarian: 1 }

  def initialize(attributes = {})
    @id = @@next_id
    @name = attributes[:name]
    @category = attributes[:category]
    @base_price = attributes[:base_price]
    @@next_id += 1
  end

  def self.create(attributes)
    pizza = new(attributes)
    if pizza.valid?
      @@pizzas << pizza
      pizza
    else
      false
    end
  end

  def self.all
    @@pizzas
  end

  def self.find(id)
    @@pizzas.find { |pizza| pizza.id == id.to_i }
  end

  def valid?
    !name.nil? && !category.nil? && !base_price.nil?
  end
end