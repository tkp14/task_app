FactoryBot.define do
  factory :task do
    name "今日のタスク！"
    introduction "10時から筋トレを30分間する"
    required_time { 30 }
  end
end
