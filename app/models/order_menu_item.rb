# frozen_string_literal: true

class OrderMenuItem < ApplicationRecord
  self.table_name = 'OrderMenuItems'

  belongs_to :order, class_name: 'Order', foreign_key: :order_id, inverse_of: :order_menu_items
  belongs_to :menu_item, class_name: 'MenuItem', foreign_key: :menu_item_id, inverse_of: :order_menu_items

  validates :order_id, presence: true
  validates :menu_item_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price_at_order, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validates :menu_item_id, uniqueness: { scope: :order_id }
end
# frozen_string_literal: true

class MenuItem < ApplicationRecord
  self.table_name = 'MenuItems'

  belongs_to :restaurant, class_name: 'Restaurant', foreign_key: :restaurant_id, inverse_of: :menu_items

  has_many :order_menu_items, class_name: 'OrderMenuItem', foreign_key: :menu_item_id, inverse_of: :menu_item,
                              dependent: :destroy
  has_many :orders, through: :order_menu_items, source: :order

  has_many :client_favourites, class_name: 'ClientFavourite', foreign_key: :menu_item_id, inverse_of: :menu_item,
                               dependent: :destroy
  has_many :favourited_by_clients, through: :client_favourites, source: :client

  has_many :client_recommendations, class_name: 'ClientRecommendation', foreign_key: :menu_item_id,
                                    inverse_of: :menu_item, dependent: :destroy
  has_many :recommended_to_clients, through: :client_recommendations, source: :client

  validates :restaurant_id, presence: true
  validates :name, presence: true
  validates :description, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
