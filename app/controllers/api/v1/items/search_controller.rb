class Api::V1::Items::SearchController < ApplicationController
  def search

    items = Item.find_items(params[:name])

    render json: ItemSerializer.new(items)
  end
end