json.bet do
  json.href make_a_grand_api_v1_bets_url
  json.status @status
  json.grand do
    json.id @grand.id
    json.bets @selections
  end
  json.multiplicator @multiplicador
  json.winning @ganancia
end
