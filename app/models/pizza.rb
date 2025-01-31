# frozen_string_literal: true

class Pizza
  attr_accessor :id, :name, :category, :base_price, :quantity

  @@pizzas = []
  @@next_id = 1

  SIZES = { regular: 0, medium: 1, large: 2 }.freeze
  CRUSTS = { new_hand_tossed: 0, wheat_thin_crust: 1, cheese_burst: 2, fresh_pan_pizza: 3 }.freeze
  CATEGORIES = { vegetarian: 0, non_vegetarian: 1 }.freeze

  def initialize(attributes = {})
    @id = @@next_id
    @name = attributes[:name]
    @category = attributes[:category]
    @base_price = attributes[:base_price]
    @quantity = 8
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
