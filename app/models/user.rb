class User < ApplicationRecord
  has_secure_password
  has_one :profile, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :email, uniqueness: true, presence: true
  validates :password, presence: true, length: { minimum: 3 }, confirmation: true

  delegate :name, to: :profile, allow_nil: true
  accepts_nested_attributes_for :profile

  def mine?(object)
    object&.user_id == id
  end

  def display_name
    profile&.name.presence || name.presence || "匿名ユーザー"
  end

  def self.ransackable_attributes(_auth = nil)
    %w[email created_at updated_at]
  end
end
