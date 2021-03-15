ActiveAdmin.register User do
  config.per_page = [10, 50, 100, 200]

  includes :event_users, :events

  actions :index, :show

  filter :email
  filter :username

  index do
    column :id do |user|
      link_to user.id, admin_user_path(user)
    end
    column :username
    column :email
  end

  show do
    panel 'User Details' do
      table_for user do
        column :username
        column :email
        column :phone
      end
    end

    panel 'Event Details' do
      events = Event.includes(:event_users)
                    .where(event_users: {user_id: user.id})
                    .order(start_datetime: :asc)
      table_for events do
        column :title
        column :start_datetime
        column :end_datetime
        column :is_completed
        column :rsvp do |event|
          event_user = event.event_users.of_users(user.id).first
          link_to event_user.rsvp, edit_admin_event_user_path(event_user)
        end
      end
    end
  end
end
