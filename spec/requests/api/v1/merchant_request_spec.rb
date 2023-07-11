require "rails_helper"

RSpec.describe "Merchants API" do
  describe "get /api/v1/merchants" do

    it "sends a list of merchants" do
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

  describe "get /api/v1/merchants/:id" do
    it "sends one merchant" do
      merchant_1 = Merchant.create!(name: "Beezy's")

      get "/api/v1/merchants/#{merchant_1.id}"

      expect(response).to be_successful

      merchant = JSON.parse(response.body, symbolize_names: true)

      expect(merchant[:data][:id].to_i).to eq(merchant_1.id)
      expect(merchant[:data][:attributes][:name]).to be_a(String)
      expect(merchant[:data][:attributes][:name]).to eq("Beezy's")
    end
  end

  describe "get /api/v1/merchants/:id/items" do
    it "sends one merchants items" do
      merchant_1 = Merchant.create!(name: "Beezy's")

      item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
      item_1 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)
      item_1 = Item.create!(name: "PetroDragonic Apocalypse", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_1.id)

      get "/api/v1/merchants/#{merchant_1.id}/items"

      expect(response).to be_successful

      merchant_items = JSON.parse(response.body, symbolize_names: true)

      expect(merchant_items[:data].count).to eq(3)
      merchant_items[:data].each do |item|
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

end
