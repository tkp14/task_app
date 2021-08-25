FactoryBot.define do
  factory :list do
    from_user_id 2
    association :user
    association :task
  end
end
