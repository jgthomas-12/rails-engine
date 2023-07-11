require "rails_helper"

describe "Merchants API" do
  it "sends a list of merchants" do
    create_list(:merchant, 100)

    get "/api/v1/merchants"

    expect(response).to be_successful

    merchants = JSON.parse(response.body)

    expect(merchants["data"][0]["attributes"]).to have_key('name')
    expect(merchants["data"][0]["attributes"]["name"]).to be_a(String)
    expect(merchants["data"].count).to eq(100)


  end
end