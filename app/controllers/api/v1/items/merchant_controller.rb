class Api::V1::Items::MerchantController < ApplicationController
  def index
    item = Item.find(params[:item_id]).merchant
    render json: MerchantSerializer.new(item)
  end
end