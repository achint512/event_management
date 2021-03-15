ActiveAdmin.register Event do
  config.per_page = [10, 50, 100, 200]

  actions :all, except: [:destroy, :edit, :update]

  includes :event_users, :users

  filter :start_datetime, label: 'Date Range for event start-time'
  filter :end_datetime, label: 'Date Range for event end-time'

  index do
    column :id do |event|
      link_to event.id, admin_event_path(event)
    end
    column :title
    column :start_datetime, sortable: true
    column :end_datetime, sortable: true
  end

  show do
    panel 'Event Details' do
      table_for event do
        column :title
        column :start_datetime
        column :end_datetime
        column :is_allday
        column :is_completed
      end
    end

    panel 'Attendee Details' do
      table_for event.event_users do
        column :username do |event_user|
          event_user.user.username
        end
        column :email do |event_user|
          event_user.user.email
        end
        column :phone do |event_user|
          event_user.user.phone
        end
        column :rsvp
      end
    end
  end
end
