Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :users, only: %w[index show create update destroy] do
    member do
      post 'follow'
      post 'unfollow'
    end

    resources :sleep_routines, only: %w[index create update]
  end

  post '/auth/login', to: 'authentication#login'
end
