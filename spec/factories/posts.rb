FactoryBot.define do
  factory :post do
    sequence(:title) { |n| "title_#{n}" }
    sequence(:content) { |n| "content_#{n}" }
    sequence(:author_ip) { |n| "10.0.0.#{n}" }
  end
end
