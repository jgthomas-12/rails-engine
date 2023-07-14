class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, :description, :unit_price, :merchant_id, presence: true, allow_blank: false
  validates :unit_price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  def self.find_items_by_name(search_params)
    where("name ilike ?", "%#{search_params}%").order(name: :asc)
  end

  def self.find_items_by_min_price(search_params)
    where("unit_price >= ?", search_params)
  end
end