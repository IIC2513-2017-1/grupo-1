Rails.application.routes.draw do
  resources :bets
  resources :users
  resources :user_bets
  resource :sessions, only: %i[new create destroy]

  root 'bets#index'

  get '/bet_list', to: 'pages#bet_list'
  get '/follow', to: 'pages#follow_list'
  post '/follow', to: 'users#new_follow_relation'
  get '/accept_follow', to: 'pages#accept_friends'
  post '/accept_follow', to: 'users#accept_friend'
  post '/bet_list', to: 'pages#accept_a_bet'
  post '/make_up', to: 'bets#make_up_grand'
  post '/create_grand', to: 'bets#create_grand'
end
