FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    introduction { "10時から筋トレを30分間する" }
    required_time { 30 }
    association :user
  end

  trait :yesterday do
    created_at { 1.day.ago }
  end

  trait :one_week_ago do
    created_at { 1.week.ago }
  end

  trait :one_month_ago do
    created_at { 1.month.ago }
  end
end
