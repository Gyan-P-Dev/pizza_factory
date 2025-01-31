# frozen_string_literal: true

# Initialize menu data
require Rails.root.join('app/models/pizza')
require Rails.root.join('app/models/topping')
require Rails.root.join('app/models/side')
[
  { name: 'Deluxe Veggie', category: :vegetarian, base_price: { regular: 150, medium: 200, large: 325 } },
  { name: 'Cheese and corn', category: :vegetarian, base_price: { regular: 175, medium: 375, large: 475 } },
  { name: 'Paneer Tikka', category: :vegetarian, base_price: { regular: 160, medium: 290, large: 340 } },
  { name: 'Non-Veg Supreme', category: :non_vegetarian, base_price: { regular: 190, medium: 325, large: 425 } },
  { name: 'Chicken Tikka', category: :non_vegetarian, base_price: { regular: 210, medium: 370, large: 500 } },
  { name: 'Pepper Barbecue Chicken', category: :non_vegetarian, base_price: { regular: 220, medium: 380, large: 525 } }
].each { |pizza_data| Pizza.create(pizza_data) }

# Create vegetarian toppings
[
  { name: 'Black olive', price: 20, category: :vegetarian },
  { name: 'Capsicum', price: 25, category: :vegetarian },
  { name: 'Paneer', price: 35, category: :vegetarian },
  { name: 'Mushroom', price: 30, category: :vegetarian },
  { name: 'Fresh tomato', price: 10, category: :vegetarian },
  { name: 'Extra cheese', price: 35, category: :vegetarian }
].each { |topping_data| Topping.create(topping_data) }

# Create non-vegetarian toppings
[
  { name: 'Chicken tikka', price: 35, category: :non_vegetarian },
  { name: 'Barbeque chicken', price: 45, category: :non_vegetarian },
  { name: 'Grilled chicken', price: 40, category: :non_vegetarian }
].each { |topping_data| Topping.create(topping_data) }

# Create sides
[
  { name: 'Cold drink', price: 55 },
  { name: 'Mousse cake', price: 90 }
].each { |side_data| Side.create(side_data) }
