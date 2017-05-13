# This file should contain all the record creation needed to seed the database
# The data can then be loaded with the rails db:seed command (or created alongsi
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }
#   Character.create(name: 'Luke', movie: movies.first)
#

user_amount = 10
competitor_amount = 100
bet_amount = 30
grands_amount = 10
user_bets_amount = 50
bet_per_grand = 3

user_amount.times do
  User.create!(
    username: Faker::Internet.unique.user_name(6..40),
    name: Faker::Name.first_name,
    role: 'gambler',
    money: 1000,
    email: Faker::Internet.unique.email,
    lastname: Faker::Name.last_name,
    password_digest: Faker::Internet.password
  )
end
competitor_amount.times do
  Competitor.create!(
    country: Faker::Address.country,
    name: Faker::Team.unique.name,
    sport: 'football'
  )
end
bet_amount.times do
  bet = Bet.new(
    sport: 'football',
    country: Faker::Address.country,
    tournament: Faker::Company.name,
    start_date: DateTime.current + Random.rand(1..10).days,
    pay_per_tie: 2
  )
  next unless bet.save
  id1 = Competitor.order('RANDOM()').first.id
  2.times do |i|
    id2 = Competitor.order('RANDOM()').first.id
    id2 = Competitor.order('RANDOM()').first.id while id2 == id1
    id1 = id2
    Part.create(
      local: i,
      multiplicator: 1 + Random.rand(0..10) / 10,
      bet_id: bet.id,
      competitor_id: id1
    )
  end
end
grands_amount.times do
  grand = Grand.create(
    amount: Random.rand(1..1000),
    user_id: User.order('RANDOM()').first.id
  )
  bet_per_grand.times do
    bet = Bet.order('RANDOM()').first
    MakeUp.create(
      grand_id: grand.id,
      bet_id: bet.id,
      selection: bet.competitors.order('RANDOM()').first.id
    )
  end
  final_date = DateTime.current - 1.years
  grand.bets.each do |bet|
    next unless final_date < bet.start_date
    final_date = bet.start_date
  end
  grand.end_date = final_date
  grand.save
end
user_bets_amount.times do
  aleatorea = Random.rand(1..50)
  UserBet.create(
    end_date: DateTime.current + (aleatorea + 2).days,
    start_date: DateTime.current + aleatorea.days,
    name: Faker::Internet.unique.user_name(7..99),
    description: Faker::Name.name,
    user_id: User.order('RANDOM()').first.id,
    challenger_amount: Random.rand(20..500),
    gambler_amount: Random.rand(20..2000),
    bet_limit: Random.rand(1..7)
  )
end
