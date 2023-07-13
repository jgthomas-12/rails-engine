class Merchant < ApplicationRecord
  has_many :items

  validates :name, presence: true

  def self.find_name(search_params)
    where("name ilike ?", "%#{search_params}%").order(name: :asc)
  end
end
