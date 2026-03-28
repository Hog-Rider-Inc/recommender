# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Recommendations::NextUserFavouritesJob do
  describe '#perform' do
    it 'does nothing when disabled' do
      allow(ENV).to receive(:fetch).with('RECOMMENDATIONS_ENABLED', 'true').and_return('0')
      expect(Client).not_to receive(:find)

      described_class.new.perform('1')
    end

    it 'runs when enabled' do
      allow(ENV).to receive(:fetch).with('RECOMMENDATIONS_ENABLED', 'true').and_return('1')

      client_favourites = instance_double(ActiveRecord::Relation)
      allow(client_favourites).to receive(:select).and_return([])

      client = instance_double(Client, id: 1, client_favourites: client_favourites)
      allow(Client).to receive(:find).with('1').and_return(client)

      domain = instance_double(Recommendations::NextUserFavourites)
      allow(Recommendations::NextUserFavourites).to receive(:new).and_return(domain)
      allow(domain).to receive(:call).and_return([1])

      job = described_class.new
      # Keep spec minimal: avoid exercising payload-building DB queries.
      allow(job).to receive(:all_items).and_return([])
      allow(job).to receive(:ordered_items_for).with(client).and_return([])
      allow(job).to receive(:existing_user_favourites_for).with(client).and_return([])
      allow(job).to receive(:disliked_user_items_for).with(client).and_return([])
      allow(job).to receive(:replace_client_recommendations!)

      job.perform('1')

      expect(Client).to have_received(:find).with('1')
      expect(domain).to have_received(:call)
      expect(job).to have_received(:replace_client_recommendations!).with(client, [1])
    end
  end
end
