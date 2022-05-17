require 'rails_helper'

describe 'Polls API', type: :request do
    describe 'GET /polls' do
        before do
            FactoryBot.create(:poll, subject: 'First poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }])
            FactoryBot.create(:poll, subject: 'Second poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }])
        end

        it 'returns all polls' do   
            get '/api/v1/polls'
      
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
            get '/api/v1/polls', params: { limit: 1 }
  
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
            get '/api/v1/polls', params: { limit: 1, offset: 1 }
  
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
        let!(:poll) { FactoryBot.create(:poll, subject: 'first poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }]) }
        
        it 'returns a poll' do
            get "/api/v1/polls/#{poll.id}"

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
        it 'create a new poll' do
            expect {
                post '/api/v1/polls', params: {
                    poll: {subject: 'The first poll?', poll_options_attributes: [{ title: 'first' }, { title: 'second' }]}
                }
            }.to change { Poll.count }.from(0).to(1)

            expect(response).to have_http_status(:created)
            expect(PollOption.count).to eq(2)
            expect(response_body).to eq(
                {
                    'id'=> Poll.first.id,
                    'subject'=> Poll.first.subject,
                    'options'=> Poll.first.poll_options.map(&:title) 
                }
            )
        end
    end

    describe 'DELETE /polls/:id' do
        let!(:poll) { FactoryBot.create(:poll, subject: 'first poll', poll_options_attributes: [{ title: 'first' }, { title: 'second' }]) }
    
        it 'deletes a poll' do
            expect {
            delete "/api/v1/polls/#{poll.id}" 
            }.to change { Poll.count }.by(-1)

            expect(response).to have_http_status(:no_content)
            expect(PollOption.count).to eq(0)
        end
    end
end