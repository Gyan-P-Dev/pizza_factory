class Order
  attr_accessor :id, :status, :order_pizzas, :sides, :errors

  @@orders = []
  @@next_id = 1

  STATUSES = { pending: 0, confirmed: 1, completed: 2 }

  def initialize(attributes = {})
    @id = @@next_id
    @status = attributes[:status] || :pending
    @order_pizzas = []
    @sides = attributes[:sides] || []
    @errors = []
    
    if attributes[:pizzas]
      attributes[:pizzas].each do |pizza_attrs|
        order_pizza = OrderPizza.new(
          pizza_id: pizza_attrs[:id],
          size: pizza_attrs[:size],
          crust: pizza_attrs[:crust],
          toppings: pizza_attrs[:topping_ids],
          base_price: pizza_attrs[:base_price]
        )
        @order_pizzas << order_pizza if order_pizza.valid?
      end
    end
    
    @@next_id += 1
  end

  def self.create(attributes)
    order = new(attributes)
    if order.valid?
      @@orders << order
      order
    else
      false
    end
  end

  def self.all
    @@orders
  end

  def self.find(id)
    @@orders.find { |order| order.id == id.to_i }
  end

  def valid?
    validate_order_pizzas && validate_sides
  end

  def total_amount
    pizza_amount = order_pizzas.sum do |order_pizza|
      pizza_price = order_pizza.base_price
      toppings = Topping.find_many(order_pizza.toppings || [])
      pizza_price + calculate_topping_charges(order_pizza, toppings)
    end

    side_amount = sides.sum do |side_order|
      side = Side.find(side_order[:id])
      side ? (side.price * side_order[:quantity]) : 0
    end

    pizza_amount + side_amount
  end

  private

  def calculate_topping_charges(order_pizza, toppings)
    return 0 if order_pizza.size == :large && toppings.count <= 2
    toppings.sum(&:price)
  end

  def validate_order_pizzas
    return add_error("No pizzas in order") if order_pizzas.empty?
    order_pizzas.all? do |order_pizza|
      validate_pizza_toppings(order_pizza)
    end
  end

  def validate_pizza_toppings(order_pizza)
    pizza = order_pizza.pizza
    toppings = Topping.find_many(order_pizza.toppings || [])
    return add_error("Invalid toppings") if toppings.any?(&:nil?)
    
    if pizza.category == :vegetarian && toppings.any?(&:non_vegetarian?)
      return add_error("Vegetarian pizza cannot have non-vegetarian toppings")
    end

    if pizza.category == :non_vegetarian
      if toppings.any? { |t| t.name == "Paneer" }
        return add_error("Non-vegetarian pizza cannot have paneer topping")
      end
      
      non_veg_toppings = toppings.select(&:non_vegetarian?)
      if non_veg_toppings.count > 1
        return add_error("Can only add one non-veg topping to non-vegetarian pizza")
      end
    end
    
    true
  end

  def validate_sides
    sides.all? do |side_order|
      side = Side.find(side_order[:id])
      return add_error("Invalid side item") unless side
      return add_error("Invalid quantity for side item") unless side_order[:quantity].to_i > 0
      true
    end
  end

  def add_error(message)
    @errors << message
    false
  end
end