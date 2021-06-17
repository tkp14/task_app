FactoryBot.define do
  factory :task do
    name { Faker::Name.name }
    introduction { "10時から筋トレを30分間する" }
    required_time { 30 }
    association :user
  end
end
