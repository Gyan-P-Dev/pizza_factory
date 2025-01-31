# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SidesController, type: :controller do
  let!(:side) { Side.create(name: 'Fries', price: 5, quantity: 10) }

  let(:valid_attributes) { { name: 'Pizza', price: 8, quantity: 10 } }
  let(:invalid_attributes) { { name: '', price: nil, quantity: nil } }

  describe 'GET #index' do
    it 'returns a list of all sides' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(Side.all.size)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'creates a new side' do
        post :create, params: { side: valid_attributes }
        created_side = Side.class_variable_get(:@@sides).last
        expect(created_side.name).to eq('Pizza')
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)['message']).to eq('Side created successfully')
      end
    end

    context 'with invalid attributes' do
      it 'does not create a new side' do
        post :create, params: { side: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['message']).to eq('Error creating side')
      end
    end
  end

  describe 'GET #show' do
    it 'returns the requested side' do
      get :show, params: { id: side.id }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['name']).to eq(side.name)
    end
  end

  describe 'POST #restock' do
    context 'with valid quantity' do
      it 'restocks the side' do
        post :restock, params: { id: side.id, side_quantity: 5 }
        restocked_side = Side.class_variable_get(:@@sides).find { |s| s.id == side.id }
        expect(response).to have_http_status(:ok)
        expect(restocked_side.quantity).to eq(15) # 10 + 5
        expect(JSON.parse(response.body)['message']).to eq('Side restocked successfully')
      end
    end

    context 'with invalid quantity' do
      it 'does not restock the side' do
        post :restock, params: { id: side.id, side_quantity: 0 }
        restocked_side = Side.class_variable_get(:@@sides).find { |s| s.id == side.id }
        expect(response).to have_http_status(:ok)
        expect(restocked_side.quantity).to eq(10) # Quantity remains unchanged
        expect(JSON.parse(response.body)['message']).to eq('Side not restocked')
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid price' do
      it "updates the side's price" do
        patch :update, params: { id: side.id, price: 12 }
        updated_side = Side.class_variable_get(:@@sides).find { |s| s.id == side.id }
        expect(updated_side.price).to eq(12)
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['message']).to eq('Side updated succesfully')
      end
    end

    context 'with invalid price' do
      it "does not update the side's price" do
        patch :update, params: { id: side.id, price: nil }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
