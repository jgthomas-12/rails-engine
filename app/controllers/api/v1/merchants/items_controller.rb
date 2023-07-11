class Api::V1::Merchants::ItemsController < ApplicationController
  def index
    if params[:invalid_param]
      render json: { error: "Invalide Parameter" }, status: :bad_request
    else
      render json: ItemSerializer.new(Merchant.find(params[:merchant_id]).items)
    end
  end
end