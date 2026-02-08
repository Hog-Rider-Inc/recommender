# frozen_string_literal: true

API_KEY = ENV['RECOMMENDER_API_KEY']

raise 'API key is required' if API_KEY.to_s.empty?
