# expect(data).to have_key(:data)
#     expect(item_data).to be_a(Hash)
#     expect(item_data).to have_key(:id)
#     expect(item_data).to have_key(:type)
#     expect(item_data).to have_key(:attributes)
#     expect(item_data[:attributes]).to have_key(:name)
#     expect(item_data[:attributes][:name]).to eq(item.name)
#     expect(item_data[:attributes][:description]).to eq(item.description)
#     expect(item_data[:attributes][:unit_price]).to eq(item.unit_price)
#     expect(item_data[:attributes][:merchant_id]).to eq(item.merchant_id)



    # require 'pry'; binding.pry
    # if params[:invalid_param]
    #   render json: { error: "Invalid Parameter" }, status: :bad_request
    # else
    #   render json: MerchantSerializer.new(Merchant.find(params[:id]))
    # end

    # class Api::V1::Merchants::ItemsController < ApplicationController
    #   def index
    #     merchant = Merchant.find_by(params[:id])
    #     if !merchant
    #       render json: { error: "merchant not found" }, status: :bad_request
    #     else
    #       render json: ItemSerializer.new(merchant.items)
    #     end
    #   end
    # end