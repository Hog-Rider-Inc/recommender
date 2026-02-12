# frozen_string_literal: true

class Openrouter::Configuration
  attr_reader :url, :bearer_token, :model

  def initialize
    @url = fetch_env!('OPENROUTER_URL')
    @bearer_token = fetch_env!('OPENROUTER_API_KEY')
    @model = fetch_env!('OPENROUTER_AI_MODEL')
  end

  private

  def fetch_env!(key)
    ENV.fetch(key)
  rescue KeyError
    raise ArgumentError, "Environment variable #{key} is required. Please set #{key} to configure Openrouter."
  end
end
