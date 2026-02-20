# frozen_string_literal: true

RSpec.describe Api::Users::RecommendationsController, type: :request do
  let(:user_id) { 1 }
  let(:valid_headers) { { 'Authorization' => "Bearer #{API_KEY}" } }

  describe 'GET /api/users/:user_id/recommendations' do
    context 'when unauthenticated' do
      it 'returns 401' do
        get "/api/users/#{user_id}/recommendations"
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated' do
      context 'when recommendations exist' do
        before do
          UserRecommendation.create!(user_id: user_id, item_id: 10)
          UserRecommendation.create!(user_id: user_id, item_id: 20)
        end

        it 'returns 200 with item_ids' do
          get "/api/users/#{user_id}/recommendations", headers: valid_headers
          expect(response).to have_http_status(:ok)
          expect(JSON.parse(response.body)).to match_array([10, 20])
        end

        it 'does not return recommendations for other users' do
          UserRecommendation.create!(user_id: 999, item_id: 99)
          get "/api/users/#{user_id}/recommendations", headers: valid_headers
          expect(JSON.parse(response.body)).not_to include(99)
        end
      end

      context 'when no recommendations exist' do
        it 'returns 404' do
          get "/api/users/#{user_id}/recommendations", headers: valid_headers
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
