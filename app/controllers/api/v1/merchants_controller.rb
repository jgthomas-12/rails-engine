class Api::V1::MerchantsController < ApplicationController
  def index
    if params[:invalid_param]
      render json: { error: "Invalid Parameter" }, status: :bad_request
    else
      render json: MerchantSerializer.new(Merchant.all)
    end
  end

  def show
    if params[:invalid_param]
      render json: { error: "Invalid Parameter" }, status: :bad_request
    else
      render json: MerchantSerializer.new(Merchant.find(params[:id]))
    end
  end
end