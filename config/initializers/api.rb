# frozen_string_literal: true

API_KEY = ENV.fetch('RECOMMENDER_API_KEY', nil)

raise 'API key is required' if API_KEY.to_s.empty?
