# frozen_string_literal: true

class MenuItemImage < ApplicationRecord
  self.table_name = "MenuItemImages"

  belongs_to :menu_item, class_name: "MenuItem", foreign_key: :menu_item_id, inverse_of: :menu_item_images

  validates :menu_item_id, presence: true
  validates :image_url, presence: true
end

