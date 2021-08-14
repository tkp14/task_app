FactoryBot.define do
  factory :comment do
    user_id { 1 }
    association :task
    content "MyText"
  end
end
