# frozen_string_literal: true

class Api::Users::RecommendationsController < ApplicationController
  def index
    render json: random_recommendations.map { |rec| serialize_menu_item(rec.menu_item) }, status: :ok
  end

  def create
    Recommendations::NextUserFavouritesJob.perform_later(user_id)
    render json: {}, status: :ok
  end

  private

  def user_id
    params[:user_id]
  end

  def serialize_menu_item(menu_item)
    return nil unless menu_item

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

  def client
    @client ||= Client.find(user_id)
  end

  def random_recommendations
    @recommendations ||= ClientRecommendation
                         .includes(menu_item: [
                                     :categories,
                                     :dietary_tags,
                                     { restaurant: [], menu_item_images: [] }
                                   ])
                         .where(client_id: client.id)
                         .order(Arel.sql('RAND()'))
                         .limit(3)
  end
end
