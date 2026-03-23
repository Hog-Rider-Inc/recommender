# frozen_string_literal: true

class Order < ApplicationRecord
  self.table_name = 'Orders'

  enum :status,
       {
         pending_acceptance: 'pending_acceptance',
         preparing: 'preparing',
         prepared: 'prepared',
         in_delivery: 'in_delivery',
         delivered: 'delivered',
         canceled: 'canceled'
       },
       prefix: true

  belongs_to :client, class_name: 'Client', foreign_key: :client_id, inverse_of: :orders
  belongs_to :restaurant, class_name: 'Restaurant', foreign_key: :restaurant_id, inverse_of: :orders
  belongs_to :address, class_name: 'Address', foreign_key: :address_id, inverse_of: :orders

  has_many :order_menu_items, class_name: 'OrderMenuItem', foreign_key: :order_id, inverse_of: :order,
                              dependent: :destroy
  has_many :menu_items, through: :order_menu_items, source: :menu_item

  validates :status, presence: true
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
