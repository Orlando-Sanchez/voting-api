require 'rails_helper'
require 'devise/jwt/test_helpers'

describe 'Votes API', type: :request do
    describe 'POST /polls/:poll_id/vote' do
        let!(:first_user) { FactoryBot.create(:user, email: 'first@user.com', password: 'firstuser') }
        let!(:poll) { FactoryBot.create(:poll, subject: 'first poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id) }
        
        it 'creates a new vote and a new ballot' do
            user = first_user
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            expect {
                post "/api/v1/polls/#{poll.id}/vote", params: {
                    vote: {poll_id: poll.id, user_id: user.id},
                    poll_option_id: poll.poll_options.first.id
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

        it 'returns an error when the user already voted in the poll' do
            FactoryBot.create(:vote, poll_id: poll.id, user_id: first_user.id)
            FactoryBot.create(:ballot, poll_option_id: poll.poll_options.first.id)

            user = first_user
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            post "/api/v1/polls/#{poll.id}/vote", params: {
                vote: {poll_id: poll.id, user_id: first_user.id},
                poll_option_id: poll.poll_options.first.id
            }.to_json, headers: auth_headers

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq(
                {
                    'message'=> 'User already voted in this poll.'
                }
            )    
        end

        it 'returns an error when poll option id is invalid' do
            user = first_user
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            post "/api/v1/polls/#{poll.id}/vote", params: {
                vote: {poll_id: poll.id, user_id: first_user.id},
                poll_option_id: ''
            }.to_json, headers: auth_headers

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq(
                {
                    'poll_option'=> [
                        'must exist'
                    ]
                }
            )           
        end

        it 'returns an error when poll is closed' do
            poll.status_closed!
            
            user = first_user
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            post "/api/v1/polls/#{poll.id}/vote", params: {
                vote: {poll_id: poll.id, user_id: first_user.id},
                poll_option_id: 1
            }.to_json, headers: auth_headers

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq(
                {
                    'message'=> 'This poll is closed.'
                }
            )           
        end
    end
end