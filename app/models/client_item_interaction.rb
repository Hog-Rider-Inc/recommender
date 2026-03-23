# frozen_string_literal: true

class ClientItemInteraction < ApplicationRecord
  self.table_name = 'ClientItemInteractions'

  enum :interaction, { like: 'like', dislike: 'dislike' }, prefix: true

  belongs_to :client
  belongs_to :menu_item

  validates :interaction, presence: true
  validates :client_id, uniqueness: { scope: :menu_item_id }
end
