require 'rails_helper'
require 'devise/jwt/test_helpers'

describe 'Votes API', type: :request do
    describe 'POST /polls/:poll_id/vote' do
        let!(:first_user) { FactoryBot.create(:user, email: 'first@user.com', password: 'firstuser') }
        let!(:poll) { FactoryBot.create(:poll, subject: 'first poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }]) }
        
        it 'creates a new vote' do
            user = first_user
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            expect {
                post "/api/v1/polls/#{poll.id}/vote", params: {
                    vote: {poll_id: poll.id, user_id: first_user.id}
                }.to_json, headers: auth_headers
            }.to change { Vote.count }.from(0).to(1)

            expect(response).to have_http_status(:ok)

            expect(response_body).to eq(
                {
                  'vote'=> {
                    'id'=> Vote.first.id,
                    'poll_id'=> poll.id,
                    'user_id'=> user.id
                  }   
                }
            )           
        end
    end
end