# frozen_string_literal: true

class Api::Users::ItemInteractionsController < ApplicationController
  def show
    item = random_unseen_menu_item

    return render json: {}, status: :ok unless item

    render json: serialize_menu_item(item), status: :ok
  end

  def like
    menu_item = MenuItem.find(params[:menu_item_id])

    interaction = ClientItemInteraction.find_or_initialize_by(client_id: client.id, menu_item_id: menu_item.id)
    interaction.interaction = :like
    interaction.save!

    ClientRecommendation.find_or_create_by!(client_id: client.id, menu_item_id: menu_item.id)

    render json: {}, status: :ok
  end

  def dislike
    menu_item = MenuItem.find(params[:menu_item_id])

    interaction = ClientItemInteraction.find_or_initialize_by(client_id: client.id, menu_item_id: menu_item.id)
    interaction.interaction = :dislike
    interaction.save!

    ClientRecommendation.where(client_id: client.id, menu_item_id: menu_item.id).delete_all

    render json: {}, status: :ok
  end

  private

  def user_id
    params[:user_id]
  end

  def client
    @client ||= Client.find(user_id)
  end

  def serialize_menu_item(menu_item)
    restaurant = menu_item.restaurant
    image_url = menu_item.menu_item_images.order(created_at: :desc).limit(1).pick(:image_url)

    {
      menu_item_id: menu_item.id,
      title: menu_item.name,
      restaurant_name: restaurant&.name,
      price: menu_item.price,
      image_url: image_url,
      categories: menu_item.categories.order(:title).pluck(:title),
      dietary_tags: menu_item.dietary_tags.order(:title).pluck(:title)
    }
  end

  # rubocop:disable Metrics/AbcSize
  def random_unseen_menu_item
    seen_ids = ClientItemInteraction.where(client_id: client.id).select(:menu_item_id)
    recommended_ids = ClientRecommendation.where(client_id: client.id).select(:menu_item_id)

    MenuItem
      .includes(:categories, :dietary_tags, :menu_item_images, :restaurant)
      .where.not(id: seen_ids)
      .where.not(id: recommended_ids)
      .order(Arel.sql('RAND()'))
      .limit(1)
      .first
  end
  # rubocop:enable Metrics/AbcSize
end
