# frozen_string_literal: true

class ClientRecommendation < ApplicationRecord
  self.table_name = 'ClientRecommendations'

  belongs_to :client, class_name: 'Client', foreign_key: :client_id, inverse_of: :client_recommendations
  belongs_to :menu_item, class_name: 'MenuItem', foreign_key: :menu_item_id, inverse_of: :client_recommendations

  validates :client_id, presence: true
  validates :menu_item_id, presence: true
end
