require 'rails_helper'

describe 'Polls API', type: :request do
    describe 'GET /polls' do
        before do
            FactoryBot.create(:poll, subject: 'First poll')
            FactoryBot.create(:poll, subject: 'Second poll')
        end

        it 'returns all polls' do   
            get '/api/v1/polls'
      
                expect(response).to have_http_status(:success)
                expect(response_body.size).to eq(2)
                expect(response_body).to eq(
                    [
                        {
                            'id'=> Poll.first.id,
                            'subject'=> Poll.first.subject,
                        },
                        {
                            'id'=> Poll.second.id,
                            'subject'=> Poll.second.subject,
                        },
                    ]
                )
          end

    end


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