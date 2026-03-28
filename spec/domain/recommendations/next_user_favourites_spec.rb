# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recommendations::NextUserFavourites do
  describe '#call' do
    it 'returns next_user_favorites array from the Openrouter response content' do
      openrouter_client = instance_double(Openrouter::Client)
      allow(Openrouter).to receive(:client).and_return(openrouter_client)

      allow(openrouter_client).to receive(:post)
        .and_return({ 'choices' => [{ 'message' => { 'content' => '{"next_user_favorites":[1,2,3]}' } }] })

      result = described_class.new.call(
        all_items: [],
        ordered_items: [],
        existing_user_favourites: [],
        disliked_user_items: []
      )

      expect(result).to eq([1, 2, 3])
    end
  end
end
