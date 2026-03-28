# frozen_string_literal: true

module Recommendations
  class NextUserFavouritesJob < ApplicationJob
    queue_as :default

    def perform(user_id)
      return unless recommendations_enabled?

      client = Client.find(user_id)
      recommended_menu_item_ids = next_user_favourites_for(client)

      replace_client_recommendations!(client, recommended_menu_item_ids)

      Rails.logger.info("Successful recommendation generation for user_id=#{user_id}.")
    end

    private

    def recommendations_enabled?
      ENV.fetch('RECOMMENDATIONS_ENABLED', 'true') == '1'
    end

    def next_user_favourites_for(client)
      Recommendations::NextUserFavourites.new.call(**next_user_favourites_payload_for(client))
    end

    def next_user_favourites_payload_for(client)
      {
        all_items: menu_item_payload(all_items),
        ordered_items: menu_item_payload(ordered_items_for(client)),
        existing_user_favourites: menu_item_payload(existing_user_favourites_for(client)),
        disliked_user_items: menu_item_payload(disliked_user_items_for(client))
      }
    end

    def all_items
      @all_items ||= MenuItem.all.to_a
    end

    def ordered_items_for(client)
      MenuItem.joins(:orders).where(orders: { client_id: client.id }).distinct.to_a
    end

    def existing_user_favourites_for(client)
      favourite_ids_from_favourites = client.client_favourites.pluck(:menu_item_id)
      favourite_ids_from_likes = ClientItemInteraction.where(client_id: client.id,
                                                             interaction: 'like').pluck(:menu_item_id)

      MenuItem.where(id: (favourite_ids_from_favourites + favourite_ids_from_likes).uniq).to_a
    end

    def disliked_user_items_for(client)
      disliked_ids = ClientItemInteraction.where(client_id: client.id,
                                                 interaction: 'dislike').select(:menu_item_id)
      MenuItem.where(id: disliked_ids).distinct.to_a
    end

    def menu_item_payload(items)
      items.map { |item| { id: item.id, name: item.name, description: item.description } }
    end

    def replace_client_recommendations!(client, recommended_menu_item_ids)
      ids = Array(recommended_menu_item_ids).map(&:to_i).uniq
      ids = MenuItem.where(id: ids).pluck(:id) # keep only existing menu items

      ClientRecommendation.transaction do
        ClientRecommendation.where(client_id: client.id).delete_all

        now = Time.current
        ids.each_with_index do |menu_item_id, i|
          ClientRecommendation.create!(
            client_id: client.id,
            menu_item_id: menu_item_id,
            created_at: now,
            updated_at: now + i.seconds
          )
        end
      end
    end
  end
end
