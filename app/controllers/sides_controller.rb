# frozen_string_literal: true

class SidesController < ApplicationController
  before_action :set_side, only: %i[show restock update]

  def index
    render json: Side.all
  end

  def create
    side = Side.create(side_params) if valid_params
    if side
      render json: { side: side, message: 'Side created successfully' }, status: :created
    else
      render json: { message: 'Error creating side' }, status: :unprocessable_entity
    end
  end

  def show
    render json: @side
  end

  def restock
    if params[:side_quantity].present? && params[:side_quantity].to_i.positive?
      @side.quantity += params[:side_quantity].to_i
      return render json: { side: @side, message: 'Side restocked successfully' }
    end

    render json: { side: @side, message: 'Side not restocked' }
  end

  def update
    if params[:price].present?
      @side.price = params[:price].to_i
      render json: { side: @side, message: 'Side updated succesfully' }, status: :ok
    else
      render json: { message: 'Please provide valid price' }, status: :unprocessable_entity
    end
  end

  private

  def set_side
    @side = Side.find(params[:id])
    render json: { error: 'Side not found' }, status: :not_found unless @side
  end

  def side_params
    params.require(:side).permit(:name, :price, :quantity)
  end

  def valid_params
    data = params[:side]
    return true if data[:name].present? && data[:price].present? && data[:quantity].present?

    false
  end
end
