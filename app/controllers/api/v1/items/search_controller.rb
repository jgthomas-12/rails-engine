class Api::V1::Items::SearchController < ApplicationController
  def search
    if params[:name].present?
      items = Item.find_items_by_name(params[:name])
      render json: ItemSerializer.new(items)
    elsif params[:min_price]
      min_items = Item.find_items_by_min_price(params[:min_price])
      render json: ItemSerializer.new(min_items)
    else
      render json: { error: "Invalid search parameters" }, status: :unprocessable_entity
    end
  end
end