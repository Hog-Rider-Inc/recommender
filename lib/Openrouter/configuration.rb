# frozen_string_literal: true

class Openrouter::Configuration
  attr_reader :url, :bearer_token, :model, :temperature, :max_tokens

  TEMPERATURE = 0.0
  MAX_TOKENS = 300

  def initialize
    @url = fetch_env!('OPENROUTER_URL')
    @bearer_token = fetch_env!('OPENROUTER_API_KEY')
    @model = fetch_env!('OPENROUTER_AI_MODEL')
    @temperature = TEMPERATURE
    @max_tokens = MAX_TOKENS
  end

  private

  def fetch_env!(key)
    ENV.fetch(key)
  rescue KeyError
    raise ArgumentError, "Environment variable #{key} is required. Please set #{key} to configure Openrouter."
  end
end
