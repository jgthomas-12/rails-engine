# RSpec.shared_examples "item attributes" do
#   expect(item[:data]).to have_key(:id)
#   expect(item[:data][:id].to_i).to be_an(Integer)

#   expect(item[:data]).to have_key(:type)
#   expect(item[:data][:type]).to be_a(String)

#   expect(item[:data]).to have_key(:attributes)
#   expect(item[:data][:attributes]).to be_a(Hash)

#   expect(item[:data][:attributes]).to have_key(:name)
#   expect(item[:data][:attributes][:name]).to be_a(String)

#   expect(item[:data][:attributes]).to have_key(:description)
#   expect(item[:data][:attributes][:description]).to be_a(String)

#   expect(item[:data][:attributes]).to have_key(:unit_price)
#   expect(item[:data][:attributes][:unit_price]).to be_a(Float)

#   expect(item[:data][:attributes]).to have_key(:merchant_id)
#   expect(item[:data][:attributes][:merchant_id]).to be_an(Integer)
# end