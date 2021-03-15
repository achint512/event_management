require 'rails_helper'

RSpec.describe EventUser, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:event) { FactoryBot.create(:event) }

  describe '#ActiveModel validations' do
    context 'when an event_user for a user and event already exists' do
      it 'raises validation error' do
        FactoryBot.create(:event_user, event_id: event.id, user_id: user.id)

        expect { FactoryBot.create(
          :event_user,
          event_id: event.id,
          user_id: user.id
        ) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#rsvp_yes?' do
    let(:event_user_with_rsvp_yes) { FactoryBot.build_stubbed(
      :event_user, event_id: event.id, user_id: user.id, rsvp: EventUser.rsvps[:yes]
    ) }

    context 'when rsvp is yes' do
      it 'returns true' do
        expect(event_user_with_rsvp_yes.rsvp_yes?).to be_truthy
      end
    end

    let(:event_user_with_rsvp_not_yes) { FactoryBot.build_stubbed(
      :event_user,
      event_id: event.id,
      user_id: user.id,
      rsvp: [EventUser.rsvps[:no], EventUser.rsvps[:maybe]].sample
    ) }

    context 'when rsvp is no or maybe' do
      it 'returns false' do
        expect(event_user_with_rsvp_not_yes.rsvp_yes?).to be_falsey
      end
    end
  end

  describe '#update_rsvp_of_overlapping_events!' do
    let(:time_now) { Time.zone.now }
    let(:event1) { FactoryBot.create(
      :event, start_datetime: time_now, end_datetime: time_now + 1.hour
    ) }
    let(:event_user1) { FactoryBot.create(
      :event_user, event_id: event1.id, user_id: user.id, rsvp: EventUser.rsvps[:yes]
    ) }
    let(:event2) { FactoryBot.create(
      :event, start_datetime: time_now + 30.minutes, end_datetime: time_now + 2.hour
    ) }

    context 'when previous events rsvp is yes' do
      before do
        [event1, event_user1, event2]
      end

      context 'when new events rsvp is yes' do
        it 'updates previous events rsvp to No' do
          FactoryBot.create(
            :event_user,
            event_id: event2.id,
            user_id: user.id,
            rsvp: EventUser.rsvps[:yes]
          )

          expect(event_user1.reload.rsvp).to eql('no')
        end
      end

      context 'when new events rsvp is no' do
        it 'does not call the method' do
          expect_any_instance_of(EventUser).not_to receive(:update_rsvp_of_overlapping_events!)

          FactoryBot.create(
            :event_user,
            event_id: event2.id,
            user_id: user.id,
            rsvp: EventUser.rsvps[:no]
          )
        end
      end

      context 'when new events rsvp is maybe' do
        it 'does not call the method' do
          expect_any_instance_of(EventUser).not_to receive(:update_rsvp_of_overlapping_events!)

          FactoryBot.create(
            :event_user,
            event_id: event2.id,
            user_id: user.id,
            rsvp: EventUser.rsvps[:maybe]
          )
        end
      end
    end
  end
end
