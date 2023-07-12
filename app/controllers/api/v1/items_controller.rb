class Api::V1::ItemsController < ApplicationController
  def index
    if params[:invalid_param]
      render json: { error: "Invalid Parameter" }, status: :bad_request
    else
      render json: ItemSerializer.new(Item.all), status: :ok
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

  def update
    item = Item.find(params[:id])

    if item_params.has_key?(:merchant_id) && !Merchant.exists?(params[:merchant_id])
      render json: { error: item.errors.full_messages }, status: :bad_request
    else
      item.update(item_params)
      render json: ItemSerializer.new(item), status: :ok
    end
  end

  def destroy
    item = Item.find(params[:id])
    item.destroy
  end

  private

  def item_params
    params.require(:item).permit(:name, :description, :unit_price, :merchant_id) if params[:item].present?
  end
end