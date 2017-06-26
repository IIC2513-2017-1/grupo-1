json.bets do
  json.href api_v1_bets_url
  json.bets do
    json.array! @bets.each do |bet|
      json.sport bet.sport
      json.tournament bet.tournament
      json.start_date bet.start_date
      json.country bet.country
      json.participants @contents[bet.id]
    end
  end
end
