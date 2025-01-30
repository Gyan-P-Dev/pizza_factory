class SidesController < ApplicationController
  def index
    render json: Side.all
  end
end