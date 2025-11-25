class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post

  validates :body, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[id body created_at updated_at post_id user_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[post user]
  end
end
