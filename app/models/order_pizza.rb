class OrderPizza
  attr_accessor :id, :pizza_id, :size, :crust, :toppings, :base_price

  @@order_pizzas = []
  @@next_id = 1

  def initialize(attributes = {})
    @id = @@next_id
    @pizza_id = attributes[:pizza_id]
    @size = attributes[:size]
    @crust = attributes[:crust]
    @toppings = attributes[:toppings] || []
    @base_price = attributes[:base_price]
    @@next_id += 1
  end

  def self.create(attributes)
    order_pizza = new(attributes)
    if order_pizza.valid?
      @@order_pizzas << order_pizza
      order_pizza
    else
      false
    end
  end

  def pizza
    Pizza.find(@pizza_id)
  end

  def valid?
    return false unless pizza_id && size && crust && base_price
    return false unless Pizza::SIZES.key?(size.to_sym)
    return false unless Pizza::CRUSTS.key?(crust.to_sym)
    true
  end
end