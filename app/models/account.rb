# frozen_string_literal: true

class Account < ApplicationRecord
  self.table_name = 'Accounts'

  enum :account_type, { client: 'client', restaurant: 'restaurant' }, prefix: true

  has_one :client, class_name: 'Client', foreign_key: :account_id, inverse_of: :account, dependent: :destroy
  has_one :restaurant, class_name: 'Restaurant', foreign_key: :account_id, inverse_of: :account, dependent: :destroy

  validates :account_type, presence: true
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password_hash, presence: true
end
