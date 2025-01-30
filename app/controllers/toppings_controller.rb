class ToppingsController < ApplicationController
  def index
    render json: Topping.all
  end
  
  def show
    topping = Topping.find(params[:id])
    if topping
      render json: topping
    else
      render json: { error: 'Topping not found' }, status: :not_found
    end
  end
end