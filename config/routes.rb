Rails.application.routes.draw do
  resources :bets, only: :index
  resources :users do
    collection do
      get 'search'
    end
    member do
      get 'notifications'
      post 'notifications/accept_deny', action: 'accept_deny_notifications'
      get 'record'
      get 'confirm_email'
    end
    resources :user_bets, except: :edit do
      member do
        post 'invite'
      end
    end
  end

  # resource :sessions, only: %i[new create destroy]

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  root 'bets#index'
  get '/add_bet', to: 'bets#add_bet'
  get '/results', to: 'application#revisar_apuestas'
  get '/search', to: 'bets#search'
  get '/accept_follow', to: 'pages#accept_friends'
  get '/bet_list', to: 'pages#bet_list'
  get '/bet_list/search', to: 'pages#search_mees_bet'
  get '/follow', to: 'pages#follow_list'
  get '/assignations', to: 'pages#assignations'
  post '/follow', to: 'users#new_follow_relation'
  post '/accept_follow', to: 'users#accept_friend'
  post '/bet_list', to: 'pages#accept_a_bet'
  post '/make_up', to: 'bets#create_grand'
  post '/aceptar_rechazar', to: 'user_bets#aceptar_rechazar'
  post '/obtener_resultado', to: 'user_bets#aceptar_rechazar'
end
