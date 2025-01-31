# frozen_string_literal: true

class PizzasController < ApplicationController
  before_action :set_pizza, only: %i[show update restock]

  def index
    pizzas = Pizza.all
    pizzas = pizzas.select { |pizza| pizza.category.to_s == params[:category] } if params[:category].present?

    render json: pizzas
  end

  def create
    pizza = Pizza.create(pizza_params) if valid_params
    if pizza
      render json: { pizza: pizza, message: 'Pizza created successfully' }, status: :created
    else
      render json: { message: 'Error creating pizza' }, status: :unprocessable_entity
    end
  end

  def show
    render json: @pizza
  end

  def restock
    if params[:pizza_quantity].present? && params[:pizza_quantity].to_i.positive?
      @pizza.quantity += params[:pizza_quantity].to_i
      return render json: { pizza: @pizza, message: 'Pizza restocked successfully' }
    end

    render json: { pizza: @pizza, message: 'Pizza not restocked' }
  end

  def update
    if params[:base_price].present?
      @pizza.base_price = params[:base_price].to_i
      render json: { pizza: @pizza, message: 'Pizza updated succesfully' }, status: :ok
    else
      render json: { message: 'Please provide valid price' }, status: :unprocessable_entity
    end
  end

  private

  def set_pizza
    @pizza = Pizza.find(params[:id])
    render json: { error: 'Pizza not found' }, status: :not_found unless @pizza
  end

  def pizza_params
    params.require(:pizza).permit(:name, :category, :quantity, base_price: {})
  end

  def valid_params
    data = params[:pizza]
    if data[:name].present? && data[:category].present? && data[:quantity].present? && data[:base_price].present?
      return true
    end

    false
  end
end
