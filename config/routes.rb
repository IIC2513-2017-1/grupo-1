Rails.application.routes.draw do
  root 'pages#home'
  get '/bet_list', to: 'pages#bet_list'
  get '/follow', to: 'pages#follow_list'
  post '/follow', to: 'users#new_follow_relation'
  post '/bet_list', to: 'pages#accept_a_bet'

  resources :user_bets
  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
