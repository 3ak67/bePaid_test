require 'rubygems'
require 'dotenv/load'
require 'bundler/setup'
require 'sinatra'
require "sinatra/activerecord"
Dir[File.expand_path('app/**/*.rb')].sort.each { |f| require f }


get '/ips' do
  content_type :json

  result = Post.connection.select_all("SELECT author_ip, array(SELECT login FROM users u WHERE u.id IN (SELECT user_id FROM posts pp WHERE p.author_ip = pp.author_ip)) FROM posts p GROUP BY author_ip HAVING count(*) > 1").to_a
  result.each { |hash| hash['authors'] = hash.delete('array').delete('{}').split(',') }
  status 200
  body result.to_json
end

get '/most_popular' do
  content_type :json
  n = params[:n] || 50

  status 200
  body Post.where.not(avg_rating: nil).order(avg_rating: :desc).limit(n).pluck(:title, :content, :avg_rating).to_json
end

post '/posts' do
  content_type :json

  request.body.rewind
  data = JSON.parse(request.body.read)['data'] || {}
  author_ip = request.env['HTTP_REMOTE_ADDR'] || request.env['REMOTE_ADDR']
  data['author_ip'] = author_ip
  result = PostMutator.create(data)

  code = result.is_a?(Array) ? 422 : 200
  status code
  body result.to_json
end

post '/rates' do
  content_type :json

  request.body.rewind
  data = JSON.parse(request.body.read)['data']
  ActiveRecord::Base.transaction do
    post = Post.lock.find_by!(id: data['id'])
    post.rates.create!(value: data['value'])
    post.update(avg_rating: post.rates.average(:value).to_f)
  end
  status 200
  body(data: 'ok' ).to_json
rescue ActiveRecord::RecordNotFound
  status 404
rescue ActiveRecord::RecordInvalid
  status 422
end
