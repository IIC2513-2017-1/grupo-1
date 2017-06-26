json.user_bets do
  if @status
    json.href api_v1_user_user_bets_url(@user)
    json.user_bets do
      json.array! @user.user_bets do |user_bet|
        json.id user_bet.id
        json.description user_bet.description
        json.name user_bet.name
      end
    end
  else
    json.access 'Acceso no autorizado'
  end
end
