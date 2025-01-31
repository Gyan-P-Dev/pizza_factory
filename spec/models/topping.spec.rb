# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Topping, type: :model do
  before(:each) do
    # Clear the toppings list before each test
    Object.send(:remove_const, :Topping) if defined?(Topping)
    load Rails.root.join('app', 'models', 'topping.rb') # Ensure we load the class
  end

  describe 'Initialization' do
    it 'creates a new topping with valid attributes' do
      topping = Topping.new(name: 'Cheese', price: 50, category: :vegetarian)

      expect(topping.name).to eq('Cheese')
      expect(topping.price).to eq(50)
      expect(topping.category).to eq(:vegetarian)
      expect(topping.quantity).to eq(15)
    end
  end

  describe '.create' do
    it 'adds a new topping to the list if valid' do
      topping = Topping.create(name: 'Olives', price: 30, category: :vegetarian)

      expect(topping).to be_a(Topping)
      expect(Topping.all).to include(topping)
    end

    it 'returns false if topping is invalid' do
      topping = Topping.create(name: nil, price: 30, category: :vegetarian)

      expect(topping).to be false
    end
  end

  describe '.all' do
    it 'returns all created toppings' do
      Topping.create(name: 'Pepperoni', price: 40, category: :non_vegetarian)
      Topping.create(name: 'Mushrooms', price: 35, category: :vegetarian)

      expect(Topping.all.size).to eq(2)
    end
  end

  describe '.find' do
    it 'finds a topping by its id' do
      topping = Topping.create(name: 'Bacon', price: 60, category: :non_vegetarian)
      found_topping = Topping.find(topping.id)

      expect(found_topping).to eq(topping)
    end

    it 'returns nil if topping is not found' do
      expect(Topping.find(999)).to be_nil
    end
  end

  describe '.find_many' do
    it 'returns multiple toppings by their ids' do
      topping1 = Topping.create(name: 'Olives', price: 30, category: :vegetarian)
      topping2 = Topping.create(name: 'Chicken', price: 45, category: :non_vegetarian)

      found_toppings = Topping.find_many([topping1.id, topping2.id])

      expect(found_toppings).to match_array([topping1, topping2])
    end
  end

  describe '#valid?' do
    it 'returns true for a valid topping' do
      topping = Topping.new(name: 'Spinach', price: 25, category: :vegetarian)
      expect(topping.valid?).to be true
    end

    it 'returns false if name is missing' do
      topping = Topping.new(name: nil, price: 30, category: :vegetarian)
      expect(topping.valid?).to be false
    end

    it 'returns false if price is missing' do
      topping = Topping.new(name: 'Tomato', price: nil, category: :vegetarian)
      expect(topping.valid?).to be false
    end

    it 'returns false if category is missing' do
      topping = Topping.new(name: 'Olives', price: 30, category: nil)
      expect(topping.valid?).to be false
    end
  end

  describe '#vegetarian?' do
    it 'returns true if the topping is vegetarian' do
      topping = Topping.new(name: 'Spinach', price: 25, category: :vegetarian)
      expect(topping.vegetarian?).to be true
    end

    it 'returns false if the topping is not vegetarian' do
      topping = Topping.new(name: 'Bacon', price: 50, category: :non_vegetarian)
      expect(topping.vegetarian?).to be false
    end
  end

  describe '#non_vegetarian?' do
    it 'returns true if the topping is non-vegetarian' do
      topping = Topping.new(name: 'Chicken', price: 45, category: :non_vegetarian)
      expect(topping.non_vegetarian?).to be true
    end

    it 'returns false if the topping is vegetarian' do
      topping = Topping.new(name: 'Olives', price: 30, category: :vegetarian)
      expect(topping.non_vegetarian?).to be false
    end
  end
end
