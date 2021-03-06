FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    introduction { "10時から筋トレを30分間する" }
    required_time { 30 }
    association :user
    created_at { Time.current }
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

  trait :picture do
    picture { Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test_task.jpg')) }
  end
end
