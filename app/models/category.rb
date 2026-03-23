# frozen_string_literal: true

class Category < ApplicationRecord
  self.table_name = 'Categories'

  has_many :menu_item_categories,
           class_name: 'MenuItemCategory',
           foreign_key: :category_id,
           inverse_of: :category,
           dependent: :destroy
  has_many :menu_items, through: :menu_item_categories, source: :menu_item

  validates :title, presence: true
end

