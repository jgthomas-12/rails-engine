require "rails_helper"

RSpec.describe "Items API", type: :request do

  describe "get /api/v1/items" do
    context "happy path" do
      it "returns a list of items when accessing GET /api/v1/items" do
        Item.destroy_all
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_3 = Item.create!(name: "PetroDragonic Apocalypse", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_2.id)

        get "/api/v1/items"

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(3)

        items[:data].each do |item|
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
        end
      end
    end

    context "sad path" do
      it "returns an error response when given an invalid parameter" do
        merchant_1 = Merchant.create!(name: "Beezy's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)

        get "/api/v1/items", params: { invalid_param: true }

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.parsed_body).to have_key("error")
      end
    end
  end

  describe "get /api/v1/items/:id" do
    context "happy path" do
      it "returns one item when accessing GET /api/v1/:id" do
        merchant_1 = Merchant.create!(name: "Beezy's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)

        get "/api/v1/items/#{item_1.id}"

        expect(response).to be_successful

        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id].to_i).to be_an(Integer)

        expect(item[:data]).to have_key(:type)
        expect(item[:data][:type]).to be_a(String)

        expect(item[:data]).to have_key(:attributes)
        expect(item[:data][:attributes]).to be_a(Hash)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)

        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)

        expect(item[:data][:id].to_i).to eq(item_1.id)
        expect(item[:data][:attributes][:name]).to eq("KG")
        expect(item[:data][:attributes][:description]).to eq("This is a record")
        expect(item[:data][:attributes][:unit_price]).to eq(1000)
        expect(item[:data][:attributes][:merchant_id]).to eq(merchant_1.id)
      end
    end

    context "sad path" do
      it "returns an error response when given an invalid parameter" do
        merchant_1 = Merchant.create!(name: "Beezy's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)

        get "/api/v1/items/#{item_1.id}", params: { invalid_param: true }

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.parsed_body).to have_key("error")
      end
    end
  end

  describe "post /api/v1/items" do
    xit "posts an item" do
      merchant_1 = Merchant.create!(name: "Beezy's")

      post "/api/v1/items"

      expect(response).to be_successful

    end
  end
end
