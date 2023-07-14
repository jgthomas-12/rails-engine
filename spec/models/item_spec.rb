require "rails_helper"

RSpec.describe Item, type: :model do
  describe "associations" do
    it { should belong_to :merchant }

    it { should have_many :invoice_items }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0).allow_nil }
    it { should validate_presence_of(:merchant_id) }
  end

  describe "class methods" do
    describe ".find_items_by_name" do
      it "finds all items by search params" do
        Merchant.destroy_all
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1000, merchant_id: merchant_1.id)
        item_3 = Item.create!(name: "PetroDragonic Apocalypse", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_2.id)
        item_4 = Item.create!(name: "KG KG KG KG", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_2.id)
        item_5 = Item.create!(name: "Bellow man, bellow 'lw' ", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_2.id)
        item_6 = Item.create!(name: "Again, kg for kicks", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_2.id)

        expect(Item.find_items_by_name("KG")).to eq([item_6, item_1, item_4])
        expect(Item.find_items_by_name("LW")).to eq([item_5, item_2])
      end
    end

    describe ".find_items_by_min_price" do
      it "finds all items by :min_price search_params, returns by value ascending" do
        Merchant.destroy_all
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")

        item_1 = Item.create!(name: "KG", description: "This is a record", unit_price: 799, merchant_id: merchant_1.id)
        item_2 = Item.create!(name: "LW", description: "This is also a record", unit_price: 1099, merchant_id: merchant_1.id)
        item_3 = Item.create!(name: "PetroDragonic Apocalypse", description: "This is so much better than Taylor Swift", unit_price: 1200, merchant_id: merchant_2.id)
        item_4 = Item.create!(name: "KG KG KG KG", description: "This is so much better than Taylor Swift", unit_price: 1000, merchant_id: merchant_2.id)
        item_5 = Item.create!(name: "Bellow man, bellow 'lw' ", description: "This is so much better than Taylor Swift", unit_price: 999, merchant_id: merchant_2.id)
        item_6 = Item.create!(name: "Again, kg for kicks", description: "This is so much better than Taylor Swift", unit_price: 899, merchant_id: merchant_2.id)

        expect(Item.find_items_by_min_price(999)).to eq([item_5, item_4, item_2, item_3])
        expect(Item.find_items_by_min_price(1150)).to eq([item_3])
      end
    end
  end
end