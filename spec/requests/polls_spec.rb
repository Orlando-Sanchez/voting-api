require 'rails_helper'

describe 'Polls API', type: :request do
    describe 'POST /polls' do 
        it 'create a new poll' do
            expect {
                post '/api/v1/polls', params: {
                    poll: {subject: 'The first poll?'}
                }
            }.to change { Poll.count }.from(0).to(1)

            expect(response).to have_http_status(:created)
            expect(response_body).to eq(
                {
                    'id'=> Poll.first.id,
                    'subject'=> Poll.first.subject,
                }
            )
        end
    end
end