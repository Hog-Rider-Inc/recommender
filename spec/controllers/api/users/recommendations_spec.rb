# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Users::RecommendationsController, type: :request do
  let!(:client_account) do
    Account.create!(email: 'c@example.com', username: 'c', password_hash: 'x', account_type: 'client')
  end
  let!(:client) { Client.create!(account: client_account, first_name: 'A', last_name: 'B') }

  let!(:restaurant_account) do
    Account.create!(email: 'r@example.com', username: 'r', password_hash: 'x', account_type: 'restaurant')
  end
  let!(:address) { Address.create!(country: 'LT', city: 'Vilnius', street: 's', postal_code: '1') }
  let!(:restaurant) do
    Restaurant.create!(account: restaurant_account, address: address, name: 'Rest', phone_number: '123')
  end

  let!(:menu_item) { MenuItem.create!(restaurant: restaurant, name: 'Dish', description: 'd', price: 9.99) }

  let(:path) { "/api/users/#{client.id}/recommendations" }
  let(:headers) { { 'Authorization' => "Token token=#{API_KEY}" } }

  describe 'GET /api/users/:user_id/recommendations' do
    subject(:make_request) { get path, headers: headers }

    it 'returns 200' do
      make_request
      expect(response).to have_http_status(:ok)
    end

    it 'returns only expected keys' do
      ClientRecommendation.create!(client: client, menu_item: menu_item)

      make_request

      body = JSON.parse(response.body)
      keys = body.first.keys.sort
      expect(keys).to eq(%w[categories dietary_tags image_url menu_item_id price restaurant_name title])
    end

    it 'includes categories and dietary_tags arrays' do
      cat = Category.create!(title: 'Burgers')
      tag = DietaryTag.create!(title: 'Vegan')
      MenuItemCategory.create!(menu_item: menu_item, category: cat)
      MenuItemDietaryTag.create!(menu_item: menu_item, dietary_tag: tag)
      ClientRecommendation.create!(client: client, menu_item: menu_item)

      make_request

      payload = JSON.parse(response.body).first
      expect(payload.fetch('categories')).to eq(['Burgers'])
      expect(payload.fetch('dietary_tags')).to eq(['Vegan'])
    end
  end

  describe 'POST /api/users/:user_id/recommendations' do
    subject(:make_request) { post path, headers: headers }

    before do
      allow(Recommendations::NextUserFavouritesJob).to receive(:perform_later)
    end

    it 'returns 200 and empty json' do
      make_request

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({})
      expect(Recommendations::NextUserFavouritesJob).to have_received(:perform_later).with(client.id.to_s)
    end
  end
end
