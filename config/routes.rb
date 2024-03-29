Rails.application.routes.draw do
  resources :bets, only: :index
  resources :users, except: :new do
    collection do
      get 'search'
    end
    member do
      get 'notifications'
      post 'notifications/accept_deny', action: 'accept_deny_notifications'
      get 'record'
      post 'manage_money'
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
  get '/set_amount', to: 'bets#set_amount'
  get '/results', to: 'application#revisar_apuestas'
  get '/search', to: 'bets#search'
  get '/friends', to: 'pages#accept_friends'
  get '/bet_list', to: 'pages#bet_list'
  get '/bet_list/search', to: 'pages#search_mees_bet'
  get '/assignations', to: 'pages#assignations'
  post '/friends/follow', to: 'users#new_follow_relation'
  post '/friends/accept_follow', to: 'users#accept_friend'
  post '/bet_list', to: 'pages#accept_a_bet'
  post '/make_up', to: 'bets#create_grand'
  post '/aceptar_rechazar', to: 'user_bets#aceptar_rechazar'
  post '/obtener_resultado', to: 'user_bets#obtener_resultado'
  post '/update_match_days', to: 'bets#add_api_matchs'

  # api
  namespace :api do
    namespace :v1 do
      resources :users, only: %i[show index] do
        resources :user_bets, only: %i[show index create]
      end
      post 'obtener_resultado', to: 'user_bets#obtener_resultado'
      post 'accept_a_bet', to: 'user_bets#accept_a_bet'
      resources :bets, only: %i[index show] do
        collection do
          post 'make_a_grand'
          get 'check_bets'
        end
      end
    end
  end
end
