FactoryBot.define do
  factory :favorite do
    association :user
    association :task
  end
end
