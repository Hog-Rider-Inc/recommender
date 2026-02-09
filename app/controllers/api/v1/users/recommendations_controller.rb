# frozen_string_literal: true

class Api::V1::Users::RecommendationsController < ApplicationController
  def index
    render status: 200, json: {}
  end
end
