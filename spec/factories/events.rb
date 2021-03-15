FactoryBot.define do
  factory :event do
    title { "MyString" }
    start_datetime { "2021-01-23 01:04:59" }
    end_datetime { "2021-01-23 01:05:59" }
    description { "MyString" }
    is_allday { false }
    is_completed { false }
  end
end
