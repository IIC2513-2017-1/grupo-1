Rails.application.routes.draw do

  resources :bets
  root 'sessions#new'
  get '/bet_list', to: 'pages#bet_list'
  get '/follow', to: 'pages#follow_list'
  post '/follow', to: 'users#new_follow_relation'
  post '/bet_list', to: 'pages#accept_a_bet'
  post '/make_up', to: 'bets#make_up_grand'
  post '/create_grand', to: 'bets#create_grand'

  resources :user_bets
  resources :users
  resource :sessions, only: [:new, :create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
