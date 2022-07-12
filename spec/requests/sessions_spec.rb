require 'rails_helper'
require 'devise/jwt/test_helpers'

describe 'Sessions API', type: :request do
    let!(:first_user) { FactoryBot.create(:user, email: 'first@user.com', password: 'firstuser') }

    describe 'POST /users/login' do
        it 'creates a new session' do
            post '/api/v1/users/login', params: {
                user: {email: first_user.email, password: first_user.password}
            }

            expect(response.headers['Authorization']).to include 'Bearer '
            expect(response).to have_http_status(:ok)
            expect(response_body).to eq(
                {
                    'message'=> 'Signed in successfully!'
                }
            )
        end
    end

    describe 'DELETE /users/logout' do
        it 'deletes a session' do
            user = first_user
            headers = { 'Accept' => 'application/json' }
            auth_headers = Devise::JWT::TestHelpers.auth_headers(headers, user)

            delete '/api/v1/users/logout', headers: auth_headers

            expect(response).to have_http_status(:ok)
            expect(response_body).to eq(
                {
                    'message'=> 'Logged out successfully.'
                }
            )
        end

        it 'returns an error when token is missing in header' do
            delete '/api/v1/users/logout'

            expect(response).to have_http_status(:unauthorized)
            expect(response_body).to eq(
                {
                    'message'=> 'Failed to log out.'
                }
            )
        end
    end
end