# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let!(:pizza) do
    Pizza.create(name: 'Margherita', category: 'veg', quantity: 10,
                 base_price: { 'regular' => 300, 'medium' => 445, 'large' => 787 })
  end
  let!(:topping1) { Topping.create(name: 'Cheese', price: 50, category: :vegetarian, quantity: 100) }
  let!(:topping2) { Topping.create(name: 'Olives', price: 40, category: :vegetarian, quantity: 50) }
  let!(:side) { Side.create(name: 'Garlic Bread', price: 100, quantity: 50) }

  let(:valid_order_attributes) do
    {
      pizzas: [
        {
          id: pizza.id,
          size: 'large',
          crust: 'cheese_burst',
          base_price: 325,
          topping_ids: [topping1.id, topping2.id]
        }
      ],
      sides: [
        { id: side.id, quantity: 2 }
      ]
    }
  end

  let(:invalid_order_attributes) do
    {
      pizzas: [
        {
          id: pizza.id,
          size: nil, # Invalid size
          crust: 'cheese_burst',
          base_price: 325,
          topping_ids: [topping1.id, topping2.id]
        }
      ]
    }
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new order' do
        post :create, params: { order: valid_order_attributes }
        response_data = JSON.parse(response.body)
        order = Order.find(response_data['id'])
        expect(order).to be_present
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['status']).to eq('pending')
        expect(order.order_pizzas.count).to eq(1)
        expect(order.sides.count).to eq(1)
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new order' do
        post :create, params: { order: invalid_order_attributes }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['errors']).to be_present
      end
    end
  end

  describe 'GET #show' do
    context 'when the order exists' do
      it 'returns the order details' do
        post :create, params: { order: valid_order_attributes }
        response_data = JSON.parse(response.body)
        order = Order.find(response_data['id'])
        get :show, params: { id: order.id }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['status']).to eq(order.status.to_s)
        expect(JSON.parse(response.body)['pizzas'].length).to eq(1)
        expect(JSON.parse(response.body)['sides'].length).to eq(1)
        expect(JSON.parse(response.body)['total_amount']).to eq(order.total_amount)
      end
    end

    context 'when the order does not exist' do
      it 'returns an error' do
        get :show, params: { id: 999_999 } # Invalid order ID

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)['error']).to eq('Order not found')
      end
    end
  end
end
