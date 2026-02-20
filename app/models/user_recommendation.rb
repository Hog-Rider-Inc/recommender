# frozen_string_literal: true

class UserRecommendation < ApplicationRecord
  scope :recent_for_user, lambda { |user_id, count = 3|
    where(user_id: user_id).order(created_at: :desc).limit(count)
  }
end
