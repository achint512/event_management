require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build_stubbed(:user) }

  describe '#ActiveModel validations' do
    context 'when username blank' do
      it 'raises validation error' do
        expect { FactoryBot.create(:user, username: '') }.
          to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when duplicate email' do
      it 'raises validation error' do
        user = FactoryBot.create(:user, email: 'test@gmail.com')

        expect { FactoryBot.create(:user, email: 'test@gmail.com') }.
          to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '.seed_data' do
    let(:csv_path) { 'tmp/users_test.csv' }

    it 'loads data from csv file' do
      before_seeding_users_count = User.count
      User.seed_data(csv_path)
      after_seeding_users_count = User.count

      expect(after_seeding_users_count - before_seeding_users_count).to eq(2)
    end
  end
end
