require 'spec_helper'

RSpec.describe 'POST /rates' do
  subject { post '/rates', params.to_json, headers }
  let(:params) { {} }
  let(:headers) { {'Content-Type': 'application/json'} }
  let(:user) { create(:user) }
  let(:a_post) { create(:post, user: user) }
  let(:rates) { build_list(:rate, 4) }

  context 'when valid params' do
    before do
      params['data'] = { id: a_post.id, value: rates.sample.value }
    end

    it 'creates a rate' do
      expect { subject }.to change(Rate, :count).by(1)
    end

    it 'has correct avg rate' do
      rates = [1, 2, 3, 4, 5]
      threads = []
      rates.each do |rate|
        threads << Thread.new do
          sleep rand(3)
          post '/rates', { data: {id: a_post.id, value: rate} }.to_json, headers
        end
      end

      # threads << Thread.new do
      #   post '/rates', { data: {id: a_post.id, value: 5} }.to_json, headers
      # end
      threads.each(&:join)
      expect(a_post.reload.avg_rating).to eq 3.0
    end
  end
end
