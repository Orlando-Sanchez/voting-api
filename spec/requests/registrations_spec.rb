require 'rails_helper'

describe 'Registrations API', type: :request do
    describe 'POST /users' do
        it 'creates a new user' do
            expect {
                post '/api/v1/users', params: {
                    user: {email: "first@user.com", password: "firstuser"}
                }
            }.to change { User.count }.from(0).to(1)

            expect(response).to have_http_status(:created)
            expect(response_body).to eq(
                {
                    "message"=> "Signed up successfully!"
                }
            )
        end

        it 'returns error when email is missing' do
            post '/api/v1/users', params: {
                user: {email: "", password: "firstuser"}
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                "error"=> { "email or password" => "is invalid" }
            })
        end

        it 'returns error when password is missing' do
            post '/api/v1/users', params: {
                user: {email: "first@user.com", password: ""}
            }

            expect(response).to have_http_status(:unprocessable_entity)
            expect(response_body).to eq({
                "error"=> { "email or password" => "is invalid" }
            })
        end
    end
end