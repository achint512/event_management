ActiveAdmin.register EventUser do
  menu false

  actions :edit, :update

  permit_params :rsvp

  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs 'Edit RSVP for event' do
      f.input :user_id, as: :string, label: 'Username', input_html: {
        value: event_user.user.username, readonly: true, disabled: true
      }
      f.input :event_id, as: :string, label: 'Event Title', input_html: {
        value: event_user.event.title, readonly: true, disabled: true
      }
      f.input :rsvp
    end

    f.actions do
      f.submit
    end
  end

  controller do
    def update
      event_user = EventUser.find(params[:id])
      event_user.rsvp = params[:event_user][:rsvp]
      event_user.save!

      redirect_to admin_user_path(event_user.user_id)
    end
  end
end
