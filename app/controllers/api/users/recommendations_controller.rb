# frozen_string_literal: true

class Api::Users::RecommendationsController < ApplicationController
  def index
    @recommendations = UserRecommendation.recent_for_user(user_id).pluck(:item_id)

    if @recommendations.empty?
      render json: [], status: :not_found
    else
      render json: @recommendations, status: :ok
    end
  end

  private

  def user_id
    params[:user_id]
  end
end
