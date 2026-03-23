# frozen_string_literal: true

class Address < ApplicationRecord
  self.table_name = 'Address'

  has_many :clients, class_name: 'Client', foreign_key: :address_id, inverse_of: :address, dependent: :nullify
  has_many :restaurants, class_name: 'Restaurant', foreign_key: :address_id, inverse_of: :address,
                         dependent: :restrict_with_exception
  has_many :orders, class_name: 'Order', foreign_key: :address_id, inverse_of: :address,
                    dependent: :restrict_with_exception

  validates :country, :city, :street, :postal_code, presence: true
end
