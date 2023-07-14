class Api::V1::Merchants::SearchController < ApplicationController
  def search
    merchant_name = Merchant.find_name(params[:name]).first

    if merchant_name
      render json: MerchantSerializer.new(merchant_name)
    else
      render json: MerchantSerializer.new(Merchant.new)
    end
  end
end

