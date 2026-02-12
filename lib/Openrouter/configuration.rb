# frozen_string_literal: true

class Openrouter::Configuration
  attr_reader :url, :bearer_token, :model

  def initialize
    @url = ENV.fetch('OPENROUTER_URL')
    @bearer_token = ENV.fetch('OPENROUTER_API_KEY')
    @model = ENV.fetch('OPENROUTER_AI_MODEL')
  end
end
