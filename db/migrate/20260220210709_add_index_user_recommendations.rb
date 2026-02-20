# frozen_string_literal: true

class AddIndexUserRecommendations < ActiveRecord::Migration[8.1]
  def up
    add_index :user_recommendations, :user_id, name: 'idx_user_id'
  end

  def down
    remove_index :user_recommendations, name: 'idx_user_id'
  end
end
