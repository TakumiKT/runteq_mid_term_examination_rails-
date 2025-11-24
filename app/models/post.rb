class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :post_tags, dependent: :destroy
  has_many :tags, through: :post_tags

  validates :title, presence: true
  validates :body, presence: true

  attr_writer :tag_name

  def tag_name
    return @tag_name if defined?(@tag_name) && @tag_name.present?

    tags.pluck(:name).join(',')
  end

  def save_tags
    return tags.clear if tag_name.blank?

    tag_list = tag_name.split(',').map(&:strip).reject(&:blank?).uniq

    tags = tag_list.map do |name|
      Tag.find_or_create_by(name: name)
    end

    self.tags = tags
  end

  def self.ransackable_attributes(_auth = nil)
    %w[title body created_at updated_at]
  end

  def self.ransackable_associations(_auth = nil)
    %w[user comments tags]
  end
end
