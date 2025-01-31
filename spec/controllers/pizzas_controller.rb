# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PizzasController, type: :controller do
  let!(:pizza) do
    Pizza.create(name: 'Margherita', category: :vegetarian, quantity: 10,
                 base_price: { regular: 300, medium: 445, large: 787 })
  end

  let(:valid_attributes) do
    { name: 'Pepperoni', category: :non_vegetarian, quantity: 15,
      base_price: { regular: 350, medium: 500, large: 850 } }
  end
  let(:invalid_attributes) { { name: '', category: nil, quantity: nil, base_price: nil } }

  describe 'GET #index' do
    it 'returns a list of all pizzas' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(Pizza.all.size)
    end

    it 'filters pizzas by category' do
      get :index, params: { category: 'vegetarian' }
      filtered_pizzas = Pizza.class_variable_get(:@@pizzas).select { |pizza| pizza.category == :vegetarian }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(filtered_pizzas.size)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new pizza' do
        post :create, params: { pizza: valid_attributes }
        created_pizza = Pizza.class_variable_get(:@@pizzas).last
        expect(created_pizza.name).to eq('Pepperoni')
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Pizza created successfully')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new pizza' do
        post :create, params: { pizza: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Error creating pizza')
      end
    end
  end

  describe 'GET #show' do
    it 'returns the requested pizza' do
      get :show, params: { id: pizza.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq(pizza.name)
    end
  end

  describe 'POST #restock' do
    context 'with valid quantity' do
      it 'restocks the pizza' do
        post :restock, params: { id: pizza.id, pizza_quantity: 5 }
        restocked_pizza = Pizza.class_variable_get(:@@pizzas).find { |p| p.id == pizza.id }
        expect(response).to have_http_status(:ok)
        expect(restocked_pizza.quantity).to eq(13)
        expect(JSON.parse(response.body)['message']).to eq('Pizza restocked successfully')
      end
    end

    context 'with invalid quantity' do
      it 'does not restock the pizza' do
        post :restock, params: { id: pizza.id, pizza_quantity: 0 }
        restocked_pizza = Pizza.class_variable_get(:@@pizzas).find { |p| p.id == pizza.id }
        expect(response).to have_http_status(:ok)
        expect(restocked_pizza.quantity).to eq(8) # Quantity remains unchanged
        expect(JSON.parse(response.body)['message']).to eq('Pizza not restocked')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid base_price' do
      it "updates the pizza's base price" do
        patch :update, params: { id: pizza.id, base_price: 12 }
        updated_pizza = Pizza.class_variable_get(:@@pizzas).find { |p| p.id == pizza.id }
        expect(updated_pizza.base_price).to eq(12)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Pizza updated succesfully')
      end
    end

    context 'with invalid base_price' do
      it "does not update the pizza's base price" do
        patch :update, params: { id: pizza.id, base_price: nil }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Please provide valid price')
      end
    end
  end
end
