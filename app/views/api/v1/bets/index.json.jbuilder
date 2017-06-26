
json.users do
  json.href api_v1_bets_url
  json.bets do
    json.array! @bets.each do |bet|
      json.id bet.id
      json.tournament bet.tournament
      json.start_date bet.start_date
    end
  end
end
