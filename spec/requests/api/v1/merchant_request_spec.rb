require "rails_helper"

RSpec.describe "Merchants API", type: :request do
  describe "get /api/v1/merchants" do
    context "happy path" do
      it "returns a list of merchants when accessing GET /api/v1/merchants" do
        Item.destroy_all
        Merchant.destroy_all

        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")
        merchant_3 = Merchant.create!(name: "Josies'")

        get "/api/v1/merchants"

        expect(response).to be_successful

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(3)

        merchants[:data].each do |merchant|
          expect(merchant).to be_a(Hash)

          expect(merchant).to have_key(:id)
          expect(merchant[:id].to_i).to be_an(Integer)

          expect(merchant).to have_key(:type)
          expect(merchant[:type]).to eq("merchant")

          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to be_a(String)
        end

        expect(merchants[:data][0][:attributes][:name]).to eq("Beezy's")
        expect(merchants[:data][1][:attributes][:name]).to eq("Joey's")
        expect(merchants[:data][2][:attributes][:name]).to eq("Josies'")
      end
    end

    context "sad path" do
      it "returns an error response when given an invalid parameter" do
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")
        merchant_3 = Merchant.create!(name: "Josies'")

        get api_v1_merchants_path, params: { invalid_param: true }

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.parsed_body).to have_key("error")
      end
    end
  end

  describe "get /api/v1/merchants/:id" do
    context "happy path" do
      it "returns one merchant when accessing GET /api/v1/merchants/:id" do
        merchant_1 = Merchant.create!(name: "Beezy's")

        get api_v1_merchant_path(merchant_1.id)

        expect(response).to be_successful

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(merchant[:data][:id].to_i).to eq(merchant_1.id)
        expect(merchant[:data][:attributes][:name]).to be_a(String)
        expect(merchant[:data][:attributes][:name]).to eq("Beezy's")
      end
    end

    context "sad path" do
      it "returns an error response when given an invalid parameter" do
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")
        merchant_3 = Merchant.create!(name: "Josies'")

        get api_v1_merchant_path(merchant_1.id), params: { invalid_param: true }

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.parsed_body).to have_key("error")
      end
    end
  end

  describe "get /api/v1/merchants/:id/items" do
    context "happy path" do
      it "returns items of a specific merchant when accessing GET /api/v1/merchants/:id/items" do
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_3 = Item.create!(name: "PetroDragonic Apocalypse", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_1.id)
        item_4 = Item.create!(name: "I'm In Your Mind Fuzz", description: "This is still so much better than Taylor Swift", unit_price: 2000, merchant_id: merchant_2.id)

        get api_v1_merchant_items_path(merchant_1.id)

        expect(response).to be_successful

        merchant_1_items = JSON.parse(response.body, symbolize_names: true)

        expect(merchant_1_items[:data].count).to eq(3)

        merchant_1_items[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id].to_i).to be_an(Integer)

          expect(item).to have_key(:type)
          expect(item[:type]).to be_a(String)

          expect(item).to have_key(:attributes)
          expect(item[:attributes]).to be_a(Hash)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a(String)

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_a(String)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_a(Float)

          expect(item[:attributes]).to have_key(:merchant_id)
          expect(item[:attributes][:merchant_id]).to be_an(Integer)

          expect(item[:attributes][:name]).to_not eq("I'm In Your Mind Fuzz")
          expect(item[:attributes][:description]).to_not eq("This is still so much better than Taylor Swift")
          expect(item[:attributes][:unit_price]).to_not eq(2000)
          expect(item[:attributes][:merchant_id]).to_not eq(merchant_2.id)
        end
      end
    end

    context "sad path" do
      it "returns an error response when given an invalid parameter" do
        merchant_1 = Merchant.create!(name: "Beezy's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)

        get api_v1_merchant_items_path(merchant_1.id), params: { invalid_param: true }

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.parsed_body).to have_key("error")
      end
    end
  end

  describe "GET /api/v1/merchants/find" do
    describe "happy path" do
      it "returns a single merchant" do
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")
        merchant_3 = Merchant.create!(name: "Beezlebub's")
        merchant_4 = Merchant.create!(name: "Delilah's")

        get "/api/v1/merchants/find?name=Beezy's"

        merchant = JSON.parse(response.body, symbolize_names: true)
        # get "/api/vi/items/find", headers: headers, params: params

        expect(response).to be_successful
        expect(response.status).to eq(200)

        expect(merchant[:data][:attributes]).to be_a(Hash)
        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to be_a(String)
        expect(merchant[:data][:attributes][:name]).to eq(merchant_1.name)
        expect(merchant[:data][:attributes][:name]).to_not eq(merchant_2.name)
        expect(merchant[:data][:attributes][:name]).to_not eq(merchant_3.name)
        expect(merchant[:data][:attributes][:name]).to_not eq(merchant_4.name)
      end
    end

    describe "sad path" do
      it "returns an successful response with no matching search" do
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")
        merchant_3 = Merchant.create!(name: "Beezlebub's")
        merchant_4 = Merchant.create!(name: "Delilah's")

        get "/api/v1/merchants/find?name=Ricks"

        non_merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)

        expect(non_merchant[:data][:id]).to eq(nil)
      end
    end
  end
end

