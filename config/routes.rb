Rails.application.routes.draw do
  devise_for :users, path: 'api/v1/users/', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: ''
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  
  namespace :api do
    namespace :v1 do
      resources :polls, only: [:index, :show, :create, :destroy]

      # TODO: ADD ENDPOINT FOR VOTE CREATION
    end
  end
end