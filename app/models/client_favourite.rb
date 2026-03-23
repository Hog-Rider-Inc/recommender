# frozen_string_literal: true

class ClientFavourite < ApplicationRecord
  self.table_name = 'ClientFavourites'

  belongs_to :client, class_name: 'Client', foreign_key: :client_id, inverse_of: :client_favourites
  belongs_to :menu_item, class_name: 'MenuItem', foreign_key: :menu_item_id, inverse_of: :client_favourites

  validates :client_id, presence: true
  validates :menu_item_id, presence: true
  validates :menu_item_id, uniqueness: { scope: :client_id }
end
