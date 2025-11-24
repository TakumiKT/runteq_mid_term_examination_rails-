require 'net/http'
require 'uri'

class SignUpForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  attribute :email, :string
  attribute :password, :string
  attribute :password_confirmation, :string
  attribute :name, :string

  validates :password, length: { minimum: 3 }
  validates :password, confirmation: true
  with_options presence: true do
    validates :email, :password, :password_confirmation, :name
  end

  validate :email_is_not_taken_by_another
  validate :github_account_must_exist

  def save
    return false if invalid?

    ActiveRecord::Base.transaction do
      user.save!
      Profile.create!(name: name, user: user)
    end
  rescue StandardError
    false
  end

  def user
    @user ||= User.new(email: email, password: password, password_confirmation: password_confirmation)
  end

  private

  def email_is_not_taken_by_another
    errors.add(:email, :taken, value: email) if User.exists?(email: email)
  end

  def github_account_must_exist
    return if name.blank?

    errors.add(:name, 'GitHubに存在するユーザー名しか登録できません') unless github_user_exists?(name)
  rescue StandardError => e
    Rails.logger.error "GitHub API Error: #{e.message}"
    errors.add(:name, 'GitHubに存在するユーザー名しか登録できません')
  end

  def github_user_exists?(username)
    uri = URI("https://github.com/#{username}")
    request = Net::HTTP::Get.new(uri)
    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    response.is_a?(Net::HTTPSuccess)
  end
end
