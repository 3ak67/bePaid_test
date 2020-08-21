FactoryBot.define do
  factory :rate do
    value { rand(1..5) }
    post
  end
end
