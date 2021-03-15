require 'csv'

class Event < ApplicationRecord
  has_many :event_users, dependent: :destroy
  has_many :users, through: :event_users

  before_save :update_end_time, if: proc { |event| event.is_allday }
  before_save :update_is_completed, if: :past_event?

  validates :title, :start_datetime, :end_datetime, presence: true
  validate :end_datetime_cannot_be_less_than_start_datetime
  validates :title, uniqueness: {
    scope: [:start_datetime, :end_datetime],
    message: 'should happen once between start_datetime and end_datetime'
  }

  scope :incomplete, -> { where(is_completed: false) }
  scope :between_start_and_end_datetime, lambda { |start_datetime, end_datetime|
    where('((:start_datetime < start_datetime AND :end_datetime > start_datetime) OR '\
           '(:start_datetime < end_datetime AND :end_datetime > end_datetime) OR '\
           '(:start_datetime < start_datetime AND :end_datetime > start_datetime) OR '\
           '(:start_datetime >= start_datetime AND :end_datetime <= end_datetime))',
          start_datetime: start_datetime, end_datetime: end_datetime)
  }
  scope :with_ids, ->(ids) { where(id: ids) }

  # Example of csv_file_with_path: 'tmp/events.csv'
  def self.seed_data(csv_file_with_path)
    CSV.foreach(csv_file_with_path, headers: true) do |row|
      ActiveRecord::Base.transaction do
        event = Event.create!(
          title: row['title'],
          start_datetime: Time.zone.parse(row['starttime']),
          end_datetime: Time.zone.parse(row['endtime']),
          description: row['description'],
          is_allday: ActiveModel::Type::Boolean.new.cast(row['allday'])
        )
        EventUser.seed_data(row['users#rsvp']&.split(';'), event.id)
      end
    rescue StandardError => e
      Rails.logger.error("Failed to insert Event, reason:#{e.inspect}")
    end
  end

  def update_end_time
    self.end_datetime = end_datetime.end_of_day
  end

  def update_is_completed
    self.is_completed = true
  end

  def past_event?
    return if end_datetime.blank?

    end_datetime < Time.zone.now
  end

  def end_datetime_cannot_be_less_than_start_datetime
    return if start_datetime.blank? || end_datetime.blank? || end_datetime > start_datetime

    errors.add(:end_datetime, "can't be less than start_datetime")
  end
end
