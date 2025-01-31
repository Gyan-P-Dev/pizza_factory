# frozen_string_literal: true

class ToppingsController < ApplicationController
  before_action :set_topping, only: %i[show restock update]

  def index
    render json: Topping.all
  end

  def create
    topping = Topping.create(topping_params) if valid_params
    if topping
      render json: { topping: topping, message: 'Topping created successfully' }, status: :created
    else
      render json: { message: 'Error creating topping' }, status: :unprocessable_entity
    end
  end

  def show
    render json: @topping
  end

  def restock
    if params[:topping_quantity].present? && params[:topping_quantity].to_i.positive?
      @topping.quantity += params[:topping_quantity].to_i
      return render json: { topping: @topping, message: 'Topping restocked successfully' }, status: :ok
    end

    render json: { topping: @topping, message: 'Topping not restocked' }, status: :unprocessable_entity
  end

  def update
    if params[:price].present?
      @topping.price = params[:price].to_i
      render json: { topping: @topping, message: 'Topping updated succesfully' }, status: :ok
    else
      render json: { message: 'Please provide valid price' }, status: :unprocessable_entity
    end
  end

  private

  def set_topping
    @topping = Topping.find(params[:id])
    render json: { error: 'Topping not found' }, status: :not_found unless @topping
  end

  def topping_params
    params.require(:topping).permit(:name, :price, :category, :quantity)
  end

  def valid_params
    data = params[:topping]
    return true if data[:name].present? && data[:price].present? && data[:quantity].present?

    false
  end
end
