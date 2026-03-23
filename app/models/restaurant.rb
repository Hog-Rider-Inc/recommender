# frozen_string_literal: true

class Restaurant < ApplicationRecord
  self.table_name = 'Restaurants'

  belongs_to :account, class_name: 'Account', foreign_key: :account_id, inverse_of: :restaurant
  belongs_to :address, class_name: 'Address', foreign_key: :address_id, inverse_of: :restaurants

  has_many :menu_items, class_name: 'MenuItem', foreign_key: :restaurant_id, inverse_of: :restaurant,
                        dependent: :destroy
  has_many :orders, class_name: 'Order', foreign_key: :restaurant_id, inverse_of: :restaurant, dependent: :destroy

  validates :name, presence: true
  validates :phone_number, presence: true
  validates :account_id, uniqueness: true
end
