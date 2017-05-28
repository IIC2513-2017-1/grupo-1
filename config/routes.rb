# == Route Map
#
#             Prefix Verb   URI Pattern                                  Controller#Action
#               bets GET    /bets(.:format)                              bets#index
#                    POST   /bets(.:format)                              bets#create
#            new_bet GET    /bets/new(.:format)                          bets#new
#           edit_bet GET    /bets/:id/edit(.:format)                     bets#edit
#                bet GET    /bets/:id(.:format)                          bets#show
#                    PATCH  /bets/:id(.:format)                          bets#update
#                    PUT    /bets/:id(.:format)                          bets#update
#                    DELETE /bets/:id(.:format)                          bets#destroy
#     user_user_bets GET    /users/:user_id/user_bets(.:format)          user_bets#index
#                    POST   /users/:user_id/user_bets(.:format)          user_bets#create
#  new_user_user_bet GET    /users/:user_id/user_bets/new(.:format)      user_bets#new
# edit_user_user_bet GET    /users/:user_id/user_bets/:id/edit(.:format) user_bets#edit
#      user_user_bet GET    /users/:user_id/user_bets/:id(.:format)      user_bets#show
#                    PATCH  /users/:user_id/user_bets/:id(.:format)      user_bets#update
#                    PUT    /users/:user_id/user_bets/:id(.:format)      user_bets#update
#                    DELETE /users/:user_id/user_bets/:id(.:format)      user_bets#destroy
#              users GET    /users(.:format)                             users#index
#                    POST   /users(.:format)                             users#create
#           new_user GET    /users/new(.:format)                         users#new
#          edit_user GET    /users/:id/edit(.:format)                    users#edit
#               user GET    /users/:id(.:format)                         users#show
#                    PATCH  /users/:id(.:format)                         users#update
#                    PUT    /users/:id(.:format)                         users#update
#                    DELETE /users/:id(.:format)                         users#destroy
#              login GET    /login(.:format)                             sessions#new
#                    POST   /login(.:format)                             sessions#create
#             logout DELETE /logout(.:format)                            sessions#destroy
#               root GET    /                                            bets#index
#           bet_list GET    /bet_list(.:format)                          pages#bet_list
#             follow GET    /follow(.:format)                            pages#follow_list
#                    POST   /follow(.:format)                            users#new_follow_relation
#                    POST   /bet_list(.:format)                          pages#accept_a_bet
#            make_up POST   /make_up(.:format)                           bets#make_up_grand
#       create_grand POST   /create_grand(.:format)                      bets#create_grand
#

Rails.application.routes.draw do
  resources :bets
  resources :users do
    collection do
      get 'search'
    end
    member do
      get 'notifications'
      get 'record'
      get 'confirm_email'
    end
    resources :user_bets do
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
  get '/search', to: 'bets#search'
  get '/accept_follow', to: 'pages#accept_friends'
  get '/bet_list', to: 'pages#bet_list'
  get '/bet_list/search', to: 'pages#search_mees_bet'
  get '/friends_bet_list', to: 'pages#friends_bet_list'
  get '/follow', to: 'pages#follow_list'
  get '/assignations', to: 'pages#assignations'
  post '/follow', to: 'users#new_follow_relation'
  post '/accept_follow', to: 'users#accept_friend'
  post '/bet_list', to: 'pages#accept_a_bet'
  post '/make_up', to: 'bets#create_grand'
end
