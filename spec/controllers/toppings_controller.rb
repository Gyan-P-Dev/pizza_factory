# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ToppingsController, type: :controller do
  let(:valid_attributes) do
    { name: 'Cheese', price: 100, category: :vegetarian, quantity: 10 }
  end

  let(:invalid_attributes) do
    { name: nil, price: nil, category: nil, quantity: nil }
  end

  let!(:topping) { Topping.create(valid_attributes) }

  describe 'GET #index' do
    it 'returns a list of all toppings' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(Topping.all.size)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new topping' do
        expect do
          post :create, params: { topping: valid_attributes }
        end.to change { Topping.class_variable_get(:@@toppings).size }.by(1)

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Topping created successfully')
      end
    end

    context 'with invalid params' do
      it 'does not create a new topping' do
        expect do
          post :create, params: { topping: invalid_attributes }
        end.to_not(change { Topping.class_variable_get(:@@toppings).size })

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Error creating topping')
      end
    end
  end

  describe 'GET #show' do
    it 'returns the requested topping' do
      get :show, params: { id: topping.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(topping.id)
    end

    it 'returns a not found message for an invalid topping' do
      get :show, params: { id: 9999 }
      expect(response).to have_http_status(:not_found)
      expect(JSON.parse(response.body)['error']).to eq('Topping not found')
    end
  end

  describe 'POST #restock' do
    context 'with valid quantity' do
      it 'restocks the topping' do
        post :restock, params: { id: topping.id, topping_quantity: 5 }

        # Find the topping in the class variable @@toppings
        restocked_topping = Topping.class_variable_get(:@@toppings).find { |t| t.id == topping.id }

        expect(response).to have_http_status(:ok)
        expect(restocked_topping.quantity).to eq(20)
        expect(JSON.parse(response.body)['message']).to eq('Topping restocked successfully')
      end
    end

    context 'with invalid quantity' do
      it 'does not restock the topping' do
        post :restock, params: { id: topping.id, topping_quantity: -5 }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(topping.quantity).to eq(15)
        expect(JSON.parse(response.body)['message']).to eq('Topping not restocked')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid params' do
      it 'updates the topping price' do
        patch :update, params: { id: topping.id, price: 120 }

        expect(response).to have_http_status(:ok)
        expect(topping.price).to eq(120)
        expect(JSON.parse(response.body)['message']).to eq('Topping updated succesfully')
      end
    end

    context 'with invalid params' do
      it 'does not update the topping price' do
        patch :update, params: { id: topping.id, price: nil }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Please provide valid price')
      end
    end
  end
end
