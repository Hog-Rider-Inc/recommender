# frozen_string_literal: true

class MenuItem < ApplicationRecord
  self.table_name = 'MenuItems'

  belongs_to :restaurant, class_name: 'Restaurant', foreign_key: :restaurant_id, inverse_of: :menu_items

  has_many :order_menu_items,
           class_name: 'OrderMenuItem',
           foreign_key: :menu_item_id,
           inverse_of: :menu_item,
           dependent: :destroy
  has_many :orders, through: :order_menu_items, source: :order

  has_many :client_favourites,
           class_name: 'ClientFavourite',
           foreign_key: :menu_item_id,
           inverse_of: :menu_item,
           dependent: :destroy

  has_many :client_recommendations,
           class_name: 'ClientRecommendation',
           foreign_key: :menu_item_id,
           inverse_of: :menu_item,
           dependent: :destroy

  validates :restaurant_id, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
