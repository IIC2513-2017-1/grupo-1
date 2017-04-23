json.extract! user_bet, :id, :name, :description, :challenger_amount, :gambler_amount, :bet_limit, :start_date, :end_date, :created_at, :updated_at
json.url user_bet_url(user_bet, format: :json)
