require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe "associations" do
    it { should have_many :items }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "class methods" do
    describe ".find_name" do
      it "finds a merchant by search param and returns them in alphabetical order" do
        Merchant.destroy_all
        merchant_1 = Merchant.create!(name: "Beezy's")
        merchant_2 = Merchant.create!(name: "Joey's")
        merchant_3 = Merchant.create!(name: "Zeke's")
        merchant_4 = Merchant.create!(name: "Bill's'")
        merchant_5 = Merchant.create!(name: "Angelic bumps")
        merchant_6 = Merchant.create!(name: "Rancid beetles")

        expect(Merchant.find_name("B")).to eq([merchant_5, merchant_1, merchant_4, merchant_6])
        expect(Merchant.find_name("b")).to eq([merchant_5, merchant_1, merchant_4, merchant_6])
      end
    end
  end
end
