# frozen_string_literal: true

class Review < ApplicationRecord
  self.table_name = "Reviews"

  belongs_to :client, class_name: "Client", foreign_key: :client_id, inverse_of: :reviews
  belongs_to :restaurant, class_name: "Restaurant", foreign_key: :restaurant_id, inverse_of: :reviews
  belongs_to :order, class_name: "Order", foreign_key: :order_id, inverse_of: :review

  validates :client_id, :restaurant_id, :order_id, presence: true
  validates :rating, presence: true, numericality: { only_integer: true }
  validates :text, presence: true
  validates :order_id, uniqueness: { scope: %i[client_id restaurant_id] }
end

