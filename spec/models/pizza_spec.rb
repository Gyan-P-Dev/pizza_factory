# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Pizza, type: :model do
  before(:each) do
    # Clear the pizza list before each test
    Object.send(:remove_const, :Pizza) if defined?(Pizza)
    # Correct the path to load pizza.rb using Rails.root
    load Rails.root.join('app', 'models', 'pizza.rb') # Ensure the correct file path
  end

  describe 'Initialization' do
    it 'creates a new pizza with valid attributes' do
      pizza = Pizza.new(name: 'Margherita', category: :vegetarian,
                        base_price: { regular: 200, medium: 300, large: 400 })

      expect(pizza.name).to eq('Margherita')
      expect(pizza.category).to eq(:vegetarian)
      expect(pizza.base_price).to eq({ regular: 200, medium: 300, large: 400 })
      expect(pizza.quantity).to eq(8)
    end
  end

  describe '.create' do
    it 'adds a new pizza to the list if valid' do
      pizza = Pizza.create(name: 'Pepperoni', category: :non_vegetarian,
                           base_price: { regular: 250, medium: 350, large: 450 })

      expect(pizza).to be_a(Pizza)
      expect(Pizza.all).to include(pizza)
    end

    it 'returns false if pizza is invalid' do
      pizza = Pizza.create(name: nil, category: :vegetarian, base_price: { regular: 200 })
      expect(pizza).to be false
    end
  end

  describe '.all' do
    it 'returns all created pizzas' do
      Pizza.create(name: 'Veggie', category: :vegetarian, base_price: { regular: 180 })
      Pizza.create(name: 'BBQ Chicken', category: :non_vegetarian, base_price: { regular: 300 })

      expect(Pizza.all.size).to eq(2)
    end
  end

  describe '.find' do
    it 'finds a pizza by its id' do
      pizza = Pizza.create(name: 'Hawaiian', category: :non_vegetarian, base_price: { regular: 320 })
      found_pizza = Pizza.find(pizza.id)

      expect(found_pizza).to eq(pizza)
    end

    it 'returns nil if pizza is not found' do
      expect(Pizza.find(999)).to be_nil
    end
  end

  describe '#valid?' do
    it 'returns true for a valid pizza' do
      pizza = Pizza.new(name: 'Cheese', category: :vegetarian, base_price: { regular: 220 })
      expect(pizza.valid?).to be true
    end

    it 'returns false if name is missing' do
      pizza = Pizza.new(name: nil, category: :vegetarian, base_price: { regular: 200 })
      expect(pizza.valid?).to be false
    end

    it 'returns false if category is missing' do
      pizza = Pizza.new(name: 'Paneer', category: nil, base_price: { regular: 250 })
      expect(pizza.valid?).to be false
    end

    it 'returns false if base_price is missing' do
      pizza = Pizza.new(name: 'Mushroom', category: :vegetarian, base_price: nil)
      expect(pizza.valid?).to be false
    end
  end
end
