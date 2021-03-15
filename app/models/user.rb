require 'csv'

class User < ApplicationRecord
  has_many :event_users, dependent: :destroy
  has_many :events, through: :event_users

  validates :email, uniqueness: true
  validates :username, presence: true

  scope :with_usernames, ->(usernames) { where(username: usernames) }

  # Example of csv_file_with_path: 'tmp/users.csv'
  def self.seed_data(csv_file_with_path)
    CSV.foreach(csv_file_with_path, headers: true) do |row|
      User.create!(
        username: row['username'],
        phone: row['phone'],
        email: row['email']
      )
    rescue StandardError => e
      Rails.logger.error("Failed to insert User, reason:#{e.inspect}")
    end
  end
end
