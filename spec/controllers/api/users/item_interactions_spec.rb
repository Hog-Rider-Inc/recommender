# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::Users::ItemInteractionsController, type: :request do
  let!(:client_account) do
    Account.create!(email: 'c2@example.com', username: 'c2', password_hash: 'x', account_type: 'client')
  end
  let!(:client) { Client.create!(account: client_account, first_name: 'A', last_name: 'B') }

  let!(:restaurant_account) do
    Account.create!(email: 'r2@example.com', username: 'r2', password_hash: 'x', account_type: 'restaurant')
  end
  let!(:address) { Address.create!(country: 'LT', city: 'Vilnius', street: 's', postal_code: '1') }
  let!(:restaurant) do
    Restaurant.create!(account: restaurant_account, address: address, name: 'Rest', phone_number: '123')
  end

  let!(:menu_item_one) { MenuItem.create!(restaurant: restaurant, name: 'Dish 1', description: 'd', price: 9.99) }
  let!(:menu_item_two) { MenuItem.create!(restaurant: restaurant, name: 'Dish 2', description: 'd', price: 10.99) }

  let(:headers) { { 'Authorization' => "Token token=#{API_KEY}" } }

  describe 'GET /api/users/:user_id/recommendations/item_interactions' do
    let(:path) { "/api/users/#{client.id}/recommendations/item_interactions" }

    it 'returns one random unseen item' do
      get path, headers: headers

      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body)
      expect(body.keys.sort).to eq(%w[categories dietary_tags image_url menu_item_id price restaurant_name title])
      expect([menu_item_one.id, menu_item_two.id]).to include(body.fetch('menu_item_id'))
    end

    it 'does not return items already interacted with or recommended' do
      ClientItemInteraction.create!(client: client, menu_item: menu_item_one, interaction: :like)
      ClientRecommendation.create!(client: client, menu_item: menu_item_two)

      get path, headers: headers

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({})
    end
  end

  describe 'POST /api/users/:user_id/recommendations/item_interactions/:menu_item_id/like' do
    let(:path) { "/api/users/#{client.id}/recommendations/item_interactions/#{menu_item_one.id}/like" }

    it 'stores like interaction and creates recommendation' do
      post path, headers: headers

      expect(response).to have_http_status(:ok)

      interaction = ClientItemInteraction.find_by!(client_id: client.id, menu_item_id: menu_item_one.id)
      expect(interaction.interaction).to eq('like')

      expect(ClientRecommendation.where(client_id: client.id, menu_item_id: menu_item_one.id)).to exist
    end
  end

  describe 'POST /api/users/:user_id/recommendations/item_interactions/:menu_item_id/dislike' do
    let(:path) { "/api/users/#{client.id}/recommendations/item_interactions/#{menu_item_one.id}/dislike" }

    it 'stores dislike interaction and removes recommendation if present' do
      ClientRecommendation.create!(client: client, menu_item: menu_item_one)

      post path, headers: headers

      expect(response).to have_http_status(:ok)

      interaction = ClientItemInteraction.find_by!(client_id: client.id, menu_item_id: menu_item_one.id)
      expect(interaction.interaction).to eq('dislike')

      expect(ClientRecommendation.where(client_id: client.id, menu_item_id: menu_item_one.id)).not_to exist
    end
  end
end
