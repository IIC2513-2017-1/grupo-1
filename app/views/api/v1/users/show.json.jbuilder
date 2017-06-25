# frozen_string_literal: true

json.user do
  json.href api_v1_user_url(@user)
  json.email @user.email
  json.first_name @user.name
  json.last_name @user.lastname
  json.user_bets do
    json.array! @user.user_bets do |user_bet|
      json.id user_bet.id
      json.description user_bet.description
      json.name user_bet.name
    end
  end
end
