class OrdersController < ApplicationController
  def create
    @order = Order.new(order_params)
    
    if Order.create(order_params)
      render json: @order, status: :created
    else
      render json: { errors: @order.errors }, status: :unprocessable_entity
    end
  end
  
  def show
    @order = Order.find(params[:id])
    if @order
      render json: {
        id: @order.id,
        status: @order.status,
        pizzas: @order.order_pizzas.map { |op| {
          id: op.pizza_id,
          name: op.pizza.name,
          size: op.size,
          crust: op.crust,
          toppings: Topping.find_many(op.toppings || []),
          base_price: op.base_price
        }},
        sides: @order.sides.map { |s| {
          id: s[:id],
          name: Side.find(s[:id])&.name,
          quantity: s[:quantity]
        }},
        total_amount: @order.total_amount
      }
    else
      render json: { error: 'Order not found' }, status: :not_found
    end
  end
  
  private
  
  def order_params
    params.require(:order).permit(
      pizzas: [:id, :size, :crust, :base_price, topping_ids: []],
      sides: [:id, :quantity]
    )
  end
end