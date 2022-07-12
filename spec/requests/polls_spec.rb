require 'rails_helper'
require 'devise/jwt/test_helpers'

describe 'Polls API', type: :request do
    let!(:first_user) { FactoryBot.create(:user, email: 'first@user.com', password: 'firstuser') }

    describe 'GET /polls' do
        before do            
            FactoryBot.create(:poll, subject: 'First poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id)
            FactoryBot.create(:poll, subject: 'Second poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id)
        end

        it 'returns all polls' do
            user = first_user
            headers = { 'Accept' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            get '/api/v1/polls', headers: auth_headers
      
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
            expect(response_body).to eq(
                [
                    {
                        'id'=> Poll.first.id,
                        'subject'=> Poll.first.subject
                    },
                    {
                        'id'=> Poll.second.id,
                        'subject'=> Poll.second.subject
                    }
                ]
            )
        end

        it 'returns a subset of polls based on limit' do
            user = first_user
            headers = { 'Accept' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            get '/api/v1/polls', params: { limit: 1 }, headers: auth_headers
  
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        'id'=> Poll.first.id,
                        'subject'=> Poll.first.subject
                    }
                ]
            )
        end
  
        it 'returns a subset of polls based on limit and offset' do
            user = first_user
            headers = { 'Accept' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            get '/api/v1/polls', params: { limit: 1, offset: 1 }, headers: auth_headers
  
            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(1)
            expect(response_body).to eq(
                [
                    {
                        'id'=> Poll.second.id,
                        'subject'=> Poll.second.subject
                    }
                ]
            )
        end
    end

    describe 'GET /polls/:id' do
        let!(:poll) { FactoryBot.create(:poll, subject: 'first poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id) }
        
        it 'returns a poll' do
            user = first_user
            headers = { 'Accept' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            
            get "/api/v1/polls/#{poll.id}", headers: auth_headers

            expect(response). to have_http_status(:success)
            expect(response_body).to eq(                
                {
                    'id'=> Poll.first.id,
                    'subject'=> Poll.first.subject,
                    'options'=> Poll.first.poll_options.map(&:title)              
                }
            )
        end
    end

    describe 'POST /polls' do 
        it 'creates a new poll' do
            user = first_user
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            expect {
                post '/api/v1/polls', params: {
                    poll: {subject: 'The first poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: user.id},

                }.to_json, headers: auth_headers
            }.to change { Poll.count }.from(0).to(1)

            expect(response).to have_http_status(:ok)
            expect(PollOption.count).to eq(2)
            expect(response_body).to eq(
                {
                    'poll'=> {
                        'id'=> Poll.first.id,
                        'subject'=> Poll.first.subject,
                        'options'=> Poll.first.poll_options.map {
                            |o| o.slice(:id, :title)
                        }
                    }   
                }
            )
        end

        it 'returns an error when subject is invalid' do
            user = first_user
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            post '/api/v1/polls', params: {
                poll: {subject: '', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: user.id}
            }.to_json, headers: auth_headers

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq(
                'subject'=> [
                    "can't be blank",
                    'is too short (minimum is 3 characters)'
                ]
            )
        end

        it 'returns an error when poll options are invalid' do
            user = first_user
            headers = { 'Accept' => 'application/json', 'Content-Type' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            post '/api/v1/polls', params: {
                poll: {subject: 'The first poll', poll_options_attributes: [{ title: '' }, { title: 'second' }], user_id: user.id}
            }.to_json, headers: auth_headers

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq(
                'poll_options.title'=> [
                    "can't be blank",
                    'is too short (minimum is 1 character)'
                ]
            )
        end
    end

    describe 'DELETE /polls/:id' do
        let!(:poll) { FactoryBot.create(:poll, subject: 'first poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id) }
    
        it 'deletes a poll' do
            user = first_user
            headers = { 'Accept' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)
            
            expect {
            delete "/api/v1/polls/#{poll.id}", headers: auth_headers
            }.to change { Poll.count }.by(-1)

            expect(response).to have_http_status(:no_content)
            expect(PollOption.count).to eq(0)
        end
    end

    describe 'GET /polls/created' do
        let!(:first_poll) { FactoryBot.create(:poll, subject: 'First poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id) }
        let!(:second_poll) { FactoryBot.create(:poll, subject: 'Second poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id) }

        it 'returns the polls created by the user' do            
            user = first_user
            headers = { 'Accept' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            get '/api/v1/polls/created', headers: auth_headers

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
            expect(response_body).to eq(
                [
                    {
                        'id'=> Poll.first.id,
                        'subject'=> Poll.first.subject
                    },
                    {
                        'id'=> Poll.second.id,
                        'subject'=> Poll.second.subject
                    }
                ]
            )
        end
    end

    describe 'GET /polls/voted' do
        let!(:first_poll) { FactoryBot.create(:poll, subject: 'First poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id) }
        let!(:second_poll) { FactoryBot.create(:poll, subject: 'Second poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }], user_id: first_user.id) }

        it 'returns the polls voted by the user' do
            FactoryBot.create(:vote, poll_id: first_poll.id, user_id: first_user.id)
            FactoryBot.create(:vote, poll_id: second_poll.id, user_id: first_user.id)
            
            user = first_user
            headers = { 'Accept' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            get '/api/v1/polls/voted', headers: auth_headers

            expect(response).to have_http_status(:success)
            expect(response_body.size).to eq(2)
            expect(response_body).to eq(
                [
                    {
                        'id'=> Poll.first.id,
                        'subject'=> Poll.first.subject
                    },
                    {
                        'id'=> Poll.second.id,
                        'subject'=> Poll.second.subject
                    }
                ]
            )
        end
    end
end