json.bet do
  json.href api_v1_bets_url(@bet)
  json.sport @bet.sport
  json.competitors @competitors
  json.country @bet.country
  json.end_date @bet.end_date
  json.start_date @bet.start_date
  json.tournament @bet.tournament
  json.result @bet.result unless @bet.result.nil?
end
