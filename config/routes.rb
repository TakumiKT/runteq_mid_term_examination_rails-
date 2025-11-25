Rails.application.routes.draw do
  root 'posts#index'
  get 'sessions/new'
  get :sign_up, to: 'users#new'
  post :sign_up, to: 'users#create'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  resources :posts do
    scope module: :posts do
      resources :comments, only: [:create, :destroy]
    end
  end

  if Rails.env.development? || Rails.env.test?
    get 'login_as/:user_id', to: 'development/sessions#login_as'
  end
end
