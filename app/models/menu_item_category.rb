# frozen_string_literal: true

class MenuItemCategory < ApplicationRecord
  self.table_name = 'MenuItemCategories'

  belongs_to :menu_item, class_name: 'MenuItem', foreign_key: :menu_item_id, inverse_of: :menu_item_categories
  belongs_to :category, class_name: 'Category', foreign_key: :category_id, inverse_of: :menu_item_categories

  validates :menu_item_id, presence: true
  validates :category_id, presence: true
end
