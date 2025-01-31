# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Side, type: :model do
  before(:each) do
    # Clear the sides list before each test
    Object.send(:remove_const, :Side) if defined?(Side)
    load Rails.root.join('app', 'models', 'side.rb') # Ensure we load the class
  end

  describe 'Initialization' do
    it 'creates a new side with valid attributes' do
      side = Side.new(name: 'Garlic Bread', price: 100)

      expect(side.name).to eq('Garlic Bread')
      expect(side.price).to eq(100)
      expect(side.quantity).to eq(10)
    end
  end

  describe '.create' do
    it 'adds a new side to the list if valid' do
      side = Side.create(name: 'French Fries', price: 50)

      expect(side).to be_a(Side)
      expect(Side.all).to include(side)
    end

    it 'returns false if side is invalid' do
      side = Side.create(name: nil, price: 50)

      expect(side).to be false
    end
  end

  describe '.all' do
    it 'returns all created sides' do
      Side.create(name: 'Onion Rings', price: 80)
      Side.create(name: 'Garlic Bread', price: 100)

      expect(Side.all.size).to eq(2)
    end
  end

  describe '.find' do
    it 'finds a side by its id' do
      side = Side.create(name: 'Cheese Sticks', price: 120)
      found_side = Side.find(side.id)

      expect(found_side).to eq(side)
    end

    it 'returns nil if side is not found' do
      expect(Side.find(999)).to be_nil
    end
  end

  describe '#valid?' do
    it 'returns true for a valid side' do
      side = Side.new(name: 'Garlic Bread', price: 60)
      expect(side.valid?).to be true
    end

    it 'returns false if name is missing' do
      side = Side.new(name: nil, price: 60)
      expect(side.valid?).to be false
    end

    it 'returns false if price is missing' do
      side = Side.new(name: 'Cheese Sticks', price: nil)
      expect(side.valid?).to be false
    end
  end
end
