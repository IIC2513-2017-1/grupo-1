json.result do
  if @status == 'check'
    json.href api_v1_obtener_resultado_url
    json.user_bet_id @user_bet.id
    json.result @result
  else
    json.alert @status
  end
end
