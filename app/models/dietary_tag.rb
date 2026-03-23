# frozen_string_literal: true

class DietaryTag < ApplicationRecord
  self.table_name = 'DietaryTags'

  has_many :menu_item_dietary_tags,
           class_name: 'MenuItemDietaryTag',
           foreign_key: :dietary_tag_id,
           inverse_of: :dietary_tag,
           dependent: :destroy
  has_many :menu_items, through: :menu_item_dietary_tags, source: :menu_item

  validates :title, presence: true
end

