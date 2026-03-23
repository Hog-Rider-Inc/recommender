# frozen_string_literal: true

class ClientRecommendation < ApplicationRecord
  self.table_name = 'ClientRecommendations'

  belongs_to :client, class_name: 'Client', foreign_key: :client_id, inverse_of: :client_recommendations
  belongs_to :menu_item, class_name: 'MenuItem', foreign_key: :menu_item_id, inverse_of: :client_recommendations

  validates :client_id, presence: true
  validates :menu_item_id, presence: true
end
# frozen_string_literal: true

class Client < ApplicationRecord
  self.table_name = 'Clients'

  belongs_to :account, class_name: 'Account', foreign_key: :account_id, inverse_of: :client
  belongs_to :address, class_name: 'Address', foreign_key: :address_id, inverse_of: :clients, optional: true

  has_many :orders, class_name: 'Order', foreign_key: :client_id, inverse_of: :client, dependent: :destroy

  has_many :client_favourites, class_name: 'ClientFavourite', foreign_key: :client_id, inverse_of: :client,
                               dependent: :destroy
  has_many :favourite_menu_items, through: :client_favourites, source: :menu_item

  has_many :client_recommendations, class_name: 'ClientRecommendation', foreign_key: :client_id, inverse_of: :client,
                                    dependent: :destroy
  has_many :recommended_menu_items, through: :client_recommendations, source: :menu_item

  validates :first_name, :last_name, presence: true
  validates :account_id, uniqueness: true
  validates :phone_number, uniqueness: true, allow_nil: true
end
