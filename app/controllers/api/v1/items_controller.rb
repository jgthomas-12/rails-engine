class Api::V1::ItemsController < ApplicationController
  def index
    if params[:invalid_param]
      render json: { error: "Invalid Parameter" }, status: :bad_request
    else
      render json: ItemSerializer.new(Item.all)
    end
  end

  def show
    if params[:invalid_param]
      render json: { error: "Invalid Parameter" }, status: :bad_request
    else
      render json: ItemSerializer.new(Item.find(params[:id]))
    end
  end

  def create
    # require 'pry'; binding.pry
  end
end