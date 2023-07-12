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
    item = Item.new(item_params)
    if item.save
      render json: ItemSerializer.new(item), status: :created
    else
      render json: { error: item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id) if params[:item].present?
  end
end