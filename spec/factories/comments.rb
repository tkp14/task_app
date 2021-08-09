FactoryBot.define do
  factory :comment do
    association :user
    association :task
    content "MyText"
  end
end
