require "rails_helper"
# require "support/item_expectations"

RSpec.describe "Items API", type: :request do

  describe "get /api/v1/items" do
    describe "happy path" do
      it "returns a list of items when accessing GET /api/v1/items" do
        Item.destroy_all
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_3 = Item.create!(name: "PetroDragonic Apocalypse", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_2.id)

        get api_v1_items_path

        expect(response).to be_successful

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(3)

        items[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id].to_i).to be_an(Integer)
          # item[:id] match to item.id

          expect(item).to have_key(:type)
          expect(item[:type]).to be_a(String)

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

    describe "sad path" do
      # resource not found
      # invalid params
      # unauthorized access
      # server errors
      # invalid response
      it "returns an error response when given an invalid parameter" do
        merchant_1 = Merchant.create!(name: "Beezy's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)

        get api_v1_items_path, params: { invalid_param: true }

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.parsed_body).to have_key("error")
      end
    end
  end

  describe "get /api/v1/items/:id" do
    describe "happy path" do
      it "returns one item when accessing GET /api/v1/:id" do
        merchant_1 = Merchant.create!(name: "Beezy's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)

        get api_v1_item_path(item_1.id)

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

    describe "sad path" do
      # resource not found
      # invalid ID format
      # related resource not found - no merchant
      it "returns an error response when given an invalid parameter" do
        merchant_1 = Merchant.create!(name: "Beezy's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)

        get api_v1_item_path(item_1.id), params: { invalid_param: true }

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.parsed_body).to have_key("error")
      end
    end
  end

  describe "post /api/v1/items" do
    describe "happy path" do
      it "posts an item when accessing POST /api/v1/items" do
        Item.destroy_all

        merchant_1 = Merchant.create!(name: "Beezy's")
        expect(Item.count).to eq(0)

        item_params = {
          name: "KG",
          description: "This is a record",
          unit_price: 1000,
          merchant_id: merchant_1.id
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post api_v1_items_path, headers: headers, params: JSON.generate(item: item_params)

        new_item = Item.last

        expect(response).to be_successful
        expect(Item.count).to eq(1)

        # expect(new_item.id).to eq(Item.all.last.id) isn't this obvious because we just assigned the new_item above?
        # is there a way to check the id?
        expect(new_item.name).to eq(item_params[:name])
        expect(new_item.description).to eq(item_params[:description])
        expect(new_item.unit_price).to eq(item_params[:unit_price])
        expect(new_item.merchant_id).to eq(item_params[:merchant_id])
      end
    end

    describe "sad path" do
      # missing required parameters
      # invalid parameters
      # unauthorized access
      # server errors
      # conflicting resource
      it "returns an error response when given an invalid parameter" do
        merchant_1 = Merchant.create!(name: "Beezy's")

        invalid_params = {
          name: "",
          description: "",
          unit_price: "sfd",
          merchant_id: merchant_1.id
        }

        headers = {"CONTENT_TYPE" => "application/json"}

        post api_v1_items_path, headers: headers, params: JSON.generate(item: invalid_params)

        expect(response).to be_unprocessable
        expect(response.status).to eq(422)
        expect(response.parsed_body).to have_key("error")
      end
    end
  end

  describe "destroy /api/v1/items" do
    describe "happy path" do
      it "deletes an item when accessing DELETE /api/v1/items" do
        Item.destroy_all
        merchant_1 = Merchant.create!(name: "Beezy's")
        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)

        expect(Item.count).to eq(1)

        delete api_v1_item_path(item_1)

        expect(response).to be_successful
        expect(Item.count).to eq(0)
        expect{ Item.find(item_1.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe "sad path" do
      it "can destroy the items invoice if it is the only item on it" do
        # Make Merchant
        # make item
        # make invoice_item
        # make invoice

        # delete item with one invoice to get success
        # try to delete item with multiple invoices and get error
        # expect response successful
        # activerecord::record not found - raise error because it's been detroyed and can't find it anymore
      end

      # it "cannot destory an items invoice if there are multiple items on it" do
      #   # merchant_1 = Merchant.create!(name: "Beezy's")

      #   # item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
      #   # item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)
      #   # item_3 = Item.create!(name: "PetroDragonic Apocalypse", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_1.id)

      #   # # make 3 Items
      #   # make 3 invoice_item
      #   # make 1 invoice

      #   # response sitll successful
      #   # status should be 404
      # end
    end
    # MAKE SAD PATH
  end

  describe "PUT /api/v1/items/:id" do
    describe "happy path" do
      it "updates an existing item" do
        merchant_1 = Merchant.create!(name: "Beezy's")
        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        previous_name = item_1.name

        item_1_params = { name: "Infest The Rat's Nest", description: "This is still also a record", unit_price: 1000, merchant_id: merchant_1.id }
        headers = {"CONTENT_TYPE" => "application/json"}

        patch api_v1_item_path(item_1), headers: headers, params: JSON.generate(item_1_params)
        updated_item = Item.find(item_1.id)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(previous_name).to_not eq(updated_item.name)
        expect(updated_item.name).to eq("Infest The Rat's Nest")
      end

      it "updates an existing item with partial data input" do
        merchant_1 = Merchant.create!(name: "Beezy's")
        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        update_params = { name: "Infest The Rat's Nest" }
        headers = {"CONTENT_TYPE" => "application/json"}

        patch api_v1_item_path(item_1), headers: headers, params: JSON.generate(update_params)
        updated_item = Item.find(item_1.id)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(updated_item.name).to eq("Infest The Rat's Nest")
        expect(updated_item.description).to eq(item_1.description)
      end
    end

    describe "sad path" do
      it "returns an error response when merchant doens't exist" do
        merchant_1 = Merchant.create!(name: "Beezy's")
        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        invalid_params = { merchant_id: 303 }
        headers = {"CONTENT_TYPE" => "application/json"}

        patch api_v1_item_path(item_1), headers: headers, params: JSON.generate(invalid_params)

        expect(response).to_not be_successful
        expect(response.status).to eq(400)
        expect(response.parsed_body).to have_key("error")
      end
    end
  end

  describe "GET /api/v1/items/:id/merchant" do
    describe "happy path" do
      it "returns the merchant of a specific item" do
        merchant_1 = Merchant.create!(name: "Beezy's")
        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)

        get api_v1_item_merchant_index_path(item_1)

        merchant = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)
        expect(merchant[:data][:id].to_i).to eq(merchant_1.id)
        expect(merchant[:data][:attributes][:name]).to eq(merchant_1.name)
      end
    end
  end

  describe "GET /api/v1/items/find_all?name=X" do
    describe "happy path" do
      it "returns a single item" do
        Item.destroy_all
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_3 = Item.create!(name: "PetroDragonic Apocalypse", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_2.id)
        item_4 = Item.create!(name: "KG KG KG KG", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_2.id)

        query_params = {
          name: "KG"
        }

        get api_v1_find_items_path, params: query_params

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to be_successful
        expect(response.status).to eq(200)

        expect(items[:data]).to be_an(Array)
        expect(items[:data][0][:attributes]).to have_key(:name)
        expect(items[:data][0][:attributes][:name]).to be_a(String)
        expect(items[:data].count).to eq(2)

        expect(items[:data].first[:attributes][:name]).to eq(item_1.name)
        expect(items[:data].second[:attributes][:name]).to eq(item_4.name)
      end
    end
  end

  describe "GET /api/v1/items/find_all?min_price=999" do
    describe "happy path" do
      it "returns all items by minimum price" do
        Item.destroy_all
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 799, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_3 = Item.create!(name: "PetroDragonic Apocalypse", description: "This is so much better than Taylor Swift", unit_price: 1200, merchant_id: merchant_2.id)
        item_4 = Item.create!(name: "KG KG KG KG", description: "This is so much better than Taylor Swift", unit_price: 1500, merchant_id: merchant_2.id)
        item_5 = Item.create!(name: "Nonagon Infinity", description: "This is so, SO, much better than Taylor Swift", unit_price: 665, merchant_id: merchant_2.id)

        query_params = {
          min_price: 999
        }

        get api_v1_find_items_path, params: query_params

        expect(response).to be_successful
        expect(response.status).to eq(200)

        items = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(items.count).to eq(3)

        items.each do |item|
          expect(item[:attributes][:unit_price]).to be >= 999
        end
      end
    end
  end
end
