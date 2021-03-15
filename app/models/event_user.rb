class EventUser < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum rsvp: [:yes, :no, :maybe]

  before_save :update_rsvp_of_overlapping_events!, if: :rsvp_yes?

  validates :user_id, uniqueness: {
    scope: :event_id,
    message: 'should have one entry per event'
  }

  scope :of_users, ->(user_ids) { where(user_id: user_ids) }
  scope :with_rsvps, ->(rsvps) { where(rsvp: rsvps) }
  scope :accepted_rsvps, -> { with_rsvps(EventUser.rsvps[:yes]) }
  scope :with_event_ids, ->(event_ids) { where(event_id: event_ids) }

  # @param [Array] user_with_rsvps user#rsvp
  # @param [Integer] event_id Event Id
  def self.seed_data(user_with_rsvps, event_id)
    return if user_with_rsvps.blank?

    username_with_rsvps = {}
    user_with_rsvps.each do |user_with_rsvp|
      username_with_rsvp = user_with_rsvp.split('#')
      username_with_rsvps[username_with_rsvp.first] = username_with_rsvp.second
    end

    User.with_usernames(username_with_rsvps.keys).find_each do |user|
      EventUser.create!(
        user_id: user.id,
        event_id: event_id,
        rsvp: EventUser.rsvps[username_with_rsvps[user.username]]
      )
    rescue StandardError => e
      Rails.logger.error("Failed to insert EventUser, reason:#{e.inspect}")
    end
  end

  def rsvp_yes?
    yes?
  end

  # Update rsvp of incomplete overlapping events to No
  def update_rsvp_of_overlapping_events!
    event_ids = Event.includes(:event_users)
                     .incomplete
                     .between_start_and_end_datetime(
                       event.start_datetime,
                       event.end_datetime
                     ).where(event_users: {user_id: user_id,
                                           rsvp: EventUser.rsvps[:yes]})
                     .pluck(:id)

    EventUser.accepted_rsvps.of_users(user_id).with_event_ids(event_ids)
             .find_each(&:no!)
  end
end
