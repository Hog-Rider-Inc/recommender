# frozen_string_literal: true

class Api::Users::RecommendationsController < ApplicationController
  def index
    render json: {}, status: :ok
  end

  private

  def user_id
    params[:user_id]
  end
end
