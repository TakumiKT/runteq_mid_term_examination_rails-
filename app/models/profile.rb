class Profile < ApplicationRecord
  belongs_to :user

  validates :name, presence: true

  def self.ransackable_attributes(_auth = nil)
    %w[id name created_at updated_at]
  end
end
