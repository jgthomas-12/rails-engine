class Item < ApplicationRecord
  belongs_to :merchant

  validates :name, :description, :unit_price, :merchant_id, presence: true, allow_blank: false
  validates :unit_price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
end