# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  before(:each) do
    # Clear the orders list before each test
    Object.send(:remove_const, :Order) if defined?(Order)
    load Rails.root.join('app', 'models', 'order.rb') # Ensure we load the class
  end

  describe 'Initialization' do
    it 'creates an order with valid attributes' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: [1], base_price: 200 }]
      side_attrs = [{ id: 1, quantity: 1 }]
      order = Order.new(status: :pending, pizzas: pizza_attrs, sides: side_attrs)

      expect(order.status).to eq(:pending)
      expect(order.order_pizzas.size).to eq(1)
      expect(order.sides.size).to eq(1)
      expect(order.errors).to be_empty
    end
  end

  describe '.create' do
    it 'creates a valid order and adds it to the order list' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: [1], base_price: 200 }]
      order = Order.create(status: :confirmed, pizzas: pizza_attrs)

      expect(order).to be_a(Order)
      expect(Order.all).to include(order)
    end

    it 'does not create an order with invalid pizzas or sides' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: nil, base_price: nil }]
      order = Order.create(status: :confirmed, pizzas: pizza_attrs)
      expect(order.errors).to eq(['No pizzas in order'])
    end
  end

  describe '.all' do
    it 'returns all orders created' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: [1], base_price: 200 }]
      Order.create(status: :confirmed, pizzas: pizza_attrs)

      expect(Order.all.size).to eq(1)
    end
  end

  describe '.find' do
    it 'finds an order by id' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: [1], base_price: 200 }]
      order = Order.create(status: :confirmed, pizzas: pizza_attrs)
      found_order = Order.find(order.id)

      expect(found_order).to eq(order)
    end

    it 'returns nil if order is not found' do
      expect(Order.find(999)).to be_nil
    end
  end

  describe '#valid?' do
    it 'returns true if the order is valid' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: [1], base_price: 200 }]
      side_attrs = [{ id: 1, quantity: 1 }]
      order = Order.new(status: :pending, pizzas: pizza_attrs, sides: side_attrs)

      expect(order.valid?).to be true
    end

    it 'returns false if pizzas are invalid' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: nil, base_price: nil }]
      order = Order.new(status: :pending, pizzas: pizza_attrs)

      expect(order.valid?).to be false
    end

    it 'returns false if side items are invalid' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: [1], base_price: 200 }]
      side_attrs = [{ id: nil, quantity: 1 }]
      order = Order.new(status: :pending, pizzas: pizza_attrs, sides: side_attrs)

      expect(order.valid?).to be false
    end
  end

  describe '#total_amount' do
    it 'calculates the correct total amount for the order' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: [1], base_price: 200 }]
      side_attrs = [{ id: 1, quantity: 2 }]
      order = Order.new(status: :pending, pizzas: pizza_attrs, sides: side_attrs)

      # Assume the prices for sides and toppings are predefined
      allow(Side).to receive(:find).and_return(double('Side', price: 50))
      allow(Topping).to receive(:find_many).and_return([double('Topping', price: 20)])

      expect(order.total_amount).to eq(200 + 50 * 2 + 20) # Pizza + sides + toppings
    end
  end

  describe '#validate_order_pizzas' do
    it 'returns false if no pizzas are in the order' do
      order = Order.new(pizzas: [])

      expect(order.send(:validate_order_pizzas)).to be false
    end

    it 'returns false for invalid toppings on a vegetarian pizza' do
      pizza_attrs = [{ id: 1, size: :regular, crust: :new_hand_tossed, topping_ids: [2], base_price: 200 }]
      order = Order.new(pizzas: pizza_attrs)

      # Simulate a non-vegetarian topping
      allow(Topping).to receive(:find_many).and_return([double('Topping', non_vegetarian?: true)])

      expect(order.send(:validate_order_pizzas)).to be false
    end
  end

  describe '#validate_sides' do
    it 'returns false if side items are invalid' do
      side_attrs = [{ id: nil, quantity: 1 }]
      order = Order.new(sides: side_attrs)

      expect(order.send(:validate_sides)).to be false
    end
  end
end
