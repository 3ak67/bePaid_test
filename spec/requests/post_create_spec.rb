require 'spec_helper'

RSpec.describe 'POST /posts' do
  subject { post '/posts', params.to_json, headers }
  let(:params) { {} }
  let(:headers) { {'Content-Type': 'application/json'} }
  let(:user) { create(:user) }
  let(:a_post) { build(:post) }
  let(:post_with_author) { build(:post, user: user) }
  let(:invalid_post) { build(:post, title: nil) }

  context 'when valid params' do
    before do
      data = a_post.as_json
      data['author'] = 'Mega Author'
      params['data'] = data
    end

    it 'respond with 200' do
      subject
      expect(last_response.status).to eq 200
    end

    it 'creates a post' do
      expect { subject }.to change(Post, :count).by(1)
    end

    it "has json content-type" do
      subject
      expect(last_response.headers['Content-Type']).to eq 'application/json'
    end

    context 'and unregistered author' do
      it 'creates new user' do
        expect { subject }.to change(User, :count).by(1)
      end
    end

    context 'and registered user' do
      before do
        params['data'] = post_with_author.as_json
      end

      it 'doesnt create new user' do
        expect { subject }.to_not change(User, :count)
      end
    end
  end

  context 'when invalid params' do
    before do
      params['data'] = invalid_post.as_json
    end

    it 'respond with 422' do
      subject
      expect(last_response.status).to eq 422
    end

    it 'doesnt create a post' do
      expect { subject }.to_not change(Post, :count)
    end
  end
end
