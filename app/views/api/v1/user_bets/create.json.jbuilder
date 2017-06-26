json.user_bet do
  if @status == 'MeesBet creada'
    json.href api_v1_user_user_bet_url @user, @user_bet
    json.name @user_bet.name
    json.description @user_bet.description
    json.challenger_amount @user_bet.challenger_amount
    json.gambler_amount @user_bet.gambler_amount
    json.bet_limit @user_bet.bet_limit
    json.start_date @user_bet.start_date
    json.end_date @user_bet.end_date
    json.result @user_bet.result
    json.exclusive @user_bet.exclusive
  else
    json.acces @status
  end
end
