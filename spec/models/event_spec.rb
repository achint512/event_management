require 'rails_helper'

RSpec.describe Event, type: :model do
  describe '#ActiveModel validations' do
    let(:time_now) { Time.zone.now }

    context 'when title blank' do
      it 'raises validation error' do
        expect { FactoryBot.create(:event, title: '') }.
          to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when start_datetime blank' do
      it 'raises validation error' do
        expect { FactoryBot.create(:event, start_datetime: '') }.
          to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when end_datetime blank' do
      it 'raises validation error' do
        expect { FactoryBot.create(:event, end_datetime: '') }.
          to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when end_datetime less than start_datetime' do
      it 'raises validation error' do
        expect { FactoryBot.create(
          :event,
          start_datetime: time_now,
          end_datetime: time_now - 1.minute
        ) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when an event with same title, start_datetime and end_datetime already exists' do
      it 'raises validation error' do
        FactoryBot.create(
          :event,
          start_datetime: time_now,
          end_datetime: time_now + 5.minutes
        )

        expect { FactoryBot.create(
          :event,
          start_datetime: time_now,
          end_datetime: time_now + 5.minutes
        ) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '.seed_data' do
    let(:user_csv_path) { 'tmp/users_test.csv' }
    let(:event_csv_path) { 'tmp/events_test.csv' }

    before do
      User.seed_data(user_csv_path)
    end

    it 'loads data from csv file' do
      before_seeding_events_count = Event.count
      Event.seed_data(event_csv_path)
      after_seeding_events_count = Event.count

      expect(after_seeding_events_count - before_seeding_events_count).to eq(3)
      expect(EventUser.count).to eq(5)
    end
  end
end
