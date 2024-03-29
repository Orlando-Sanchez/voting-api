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
      resources :polls, only: [:index, :show, :create, :destroy] do
        collection do
          get 'created' => :user_created_polls
        end
        
        collection do
          get 'voted' => :user_voted_polls
        end

        resources :votes, path: 'vote', as: 'vote', only: [:create]
      end
    end
  end
end