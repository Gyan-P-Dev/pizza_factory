# frozen_string_literal: true

class Topping
  attr_accessor :id, :name, :price, :category, :quantity

  @@toppings = []
  @@next_id = 1

  CATEGORIES = { vegetarian: 0, non_vegetarian: 1 }.freeze

  def initialize(attributes = {})
    @id = @@next_id
    @name = attributes[:name]
    @price = attributes[:price]
    @category = attributes[:category]
    @quantity = 15
    @@next_id += 1
  end

  def self.create(attributes)
    topping = new(attributes)
    if topping.valid?
      @@toppings << topping
      topping
    else
      false
    end
  end

  def self.all
    @@toppings
  end

  def self.find(id)
    @@toppings.find { |topping| topping.id == id.to_i }
  end

  def self.find_many(ids)
    ids.map { |id| find(id) }
  end

  def valid?
    !name.nil? && !price.nil? && !category.nil?
  end

  def vegetarian?
    category == :vegetarian
  end

  def non_vegetarian?
    category == :non_vegetarian
  end
end
