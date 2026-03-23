# frozen_string_literal: true

class MenuItemDietaryTag < ApplicationRecord
  self.table_name = 'MenuItemDietaryTags'

  belongs_to :menu_item, class_name: 'MenuItem', foreign_key: :menu_item_id, inverse_of: :menu_item_dietary_tags
  belongs_to :dietary_tag, class_name: 'DietaryTag', foreign_key: :dietary_tag_id, inverse_of: :menu_item_dietary_tags

  validates :menu_item_id, presence: true
  validates :dietary_tag_id, presence: true
end
