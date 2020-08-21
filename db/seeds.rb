require 'factory_bot'
require 'faraday'
include FactoryBot::Syntax::Methods
FactoryBot.find_definitions

Post.destroy_all
User.destroy_all

ips = 50.times.map { |n| "156.135.0.#{n}" }
authors = build_list(:user, 100)
create_url = 'http://localhost:4567/posts'
rate_url = 'http://localhost:4567/rates'

4.times do
  posts = build_list(:post, 50_000)

  posts.each do |post|
    data = post.as_json
    data['author'] = authors.sample.login
    response = Faraday.post(create_url, {data: data}.to_json, 'Content_Type': 'application/json', 'REMOTE_ADDR': ips.sample)
    id = JSON.parse(response.body)['id']
    threads = []
    rand(7).times do
      threads << Thread.new do
        Faraday.post(rate_url, {data: {id: id, value: rand(1..5)}}.to_json, 'Content_Type': 'application/json')
      end
    end
  end
end
