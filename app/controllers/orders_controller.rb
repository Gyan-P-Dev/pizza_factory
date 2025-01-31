# frozen_string_literal: true

class OrdersController < ApplicationController
  def create
    @order = Order.create(order_params)
    if @order.errors.any?
      render json: { errors: @order.errors }, status: :unprocessable_entity
    else
      render json: @order, status: :created
    end
  end

  def show
    @order = Order.find(params[:id])
    if @order
      render json: {
        id: @order.id,
        status: @order.status,
        pizzas: @order.order_pizzas.map do |op|
          {
            id: op.pizza_id,
            name: op.pizza.name,
            size: op.size,
            crust: op.crust,
            toppings: Topping.find_many(op.toppings || []),
            base_price: op.base_price
          }
        end,
        sides: @order.sides.map do |s|
          {
            id: s[:id],
            name: Side.find(s[:id])&.name,
            quantity: s[:quantity]
          }
        end,
        total_amount: @order.total_amount
      }
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end

  private

  def order_params
    params.require(:order).permit(
      pizzas: [:id, :size, :crust, :base_price, { topping_ids: [] }],
      sides: %i[id quantity]
    )
  end
end
