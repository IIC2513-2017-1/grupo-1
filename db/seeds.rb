# This file should contain all the record creation needed to seed the database
# The data can then be loaded with the rails db:seed command (or created alongsi
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }
#   Character.create(name: 'Luke', movie: movies.first)
#

user_amount = 10
admin_amount = 3
competitor_amount = 50
bet_amount = 30
grands_amount = 10
user_bets_amount = 20
bet_per_grand = 3

user = User.create!(
  username: Faker::Internet.unique.user_name(6..40),
  name: Faker::Name.first_name,
  role: 'admin',
  money: 10000,
  birthday: rand(80.year.ago..18.year.ago),
  description: Faker::Lorem.paragraph,
  email: 'j123@uc.cl',
  avatar: Faker::Avatar.image,
  lastname: Faker::Name.last_name,
  email_confirmed: true,
  password: '12345678',
  password_confirmation: '12345678'
)
user.confirmation_token

admin_amount.times do
  User.create(
    username: Faker::Internet.unique.user_name(6..40),
    name: Faker::Name.first_name,
    role: 'admin',
    money: 1000,
    birthday: rand(80.year.ago..18.year.ago),
    avatar: Faker::Avatar.image,
    description: Faker::Lorem.paragraph,
    email: Faker::Internet.unique.email,
    lastname: Faker::Name.last_name,
    password_digest: Faker::Internet.password
  )
end
user_amount.times do
  user2 = User.create(
    username: Faker::Internet.unique.user_name(6..40),
    name: Faker::Name.first_name,
    role: 'gambler',
    money: 5000,
    birthday: rand(80.year.ago..18.year.ago),
    avatar: Faker::Avatar.image,
    description: Faker::Lorem.paragraph,
    email: Faker::Internet.unique.email,
    email_confirmed: true,
    lastname: Faker::Name.last_name,
    password_digest: Faker::Internet.password
  )
  user2.confirmation_token
  if Random.rand(1..2) == 2
    user.following << user2
    user2.following << user
  end
end

competitor_amount.times do
  Competitor.create!(
    country: Faker::Address.country,
    name: Faker::Team.unique.name,
    sport: 'football'
  )
end
bet_amount.times do
  time = DateTime.current + Random.rand(1..10).days
  bet = Bet.new(
    sport: 'football',
    country: Faker::Address.country,
    tournament: Faker::Company.name,
    start_date: time,
    pay_per_tie: 2,
    finish: false,
    end_date: time + 2.hours
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
  bet.result = id1
  bet.save!
end
grands_amount.times do
  grand = Grand.create(
    amount: Random.rand(1..1000),
    user_id: User.order('RANDOM()').first.id,
    checked: false
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
  checked = true
  checked = nil if Random.rand(1..2) == 1
  aleatorea = Random.rand(1..50)
  user_bet = UserBet.new(
    end_date: DateTime.current + (aleatorea + 2).days,
    start_date: DateTime.current + aleatorea.days,
    name: Faker::Internet.unique.user_name(7..99),
    description: Faker::Name.name,
    user_id: User.order('RANDOM()').first.id,
    challenger_amount: Random.rand(20..500),
    gambler_amount: Random.rand(20..2000),
    bet_limit: Random.rand(1..7),
    checked: checked
  )
  if user_bet.save
    admin = User.where(role: 'admin').order('RANDOM()').first
    Assignment.create(user_id: admin.id, user_bet_id: user_bet.id)
  end
end

user_bets_amount.times do
  checked = true
  checked = false if Random.rand(1..4) == 1
  user_bet = UserBet.new(
    end_date: DateTime.current + 4.hours,
    start_date: DateTime.current + 3.hours,
    name: Faker::Internet.unique.user_name(7..99),
    description: Faker::Name.name,
    user_id: User.order('RANDOM()').first.id,
    challenger_amount: Random.rand(20..500),
    gambler_amount: Random.rand(20..2000),
    bet_limit: Random.rand(1..7),
    checked: checked
  )
  if user_bet.save
    admin = User.where(role: 'admin').order('RANDOM()').first
    Assignment.create(user_id: admin.id, user_bet_id: user_bet.id)
  end
end

user_bets_amount.times do
  user_bet = UserBet.new(
    end_date: DateTime.current - 1.hours,
    start_date: DateTime.current - 10.hours,
    name: Faker::Internet.unique.user_name(7..99),
    description: Faker::Name.name,
    user_id: User.order('RANDOM()').first.id,
    challenger_amount: Random.rand(20..500),
    gambler_amount: Random.rand(20..2000),
    bet_limit: Random.rand(1..7),
    checked: true,
    result: nil
  )
  if user_bet.save(validate: false)
    admin = User.where(role: 'admin').order('RANDOM()').first
    Assignment.create(user_id: admin.id, user_bet_id: user_bet.id)
  end
end

user_bets_amount.times do
  user_bet = UserBet.new(
    end_date: DateTime.current - 1.hours,
    start_date: DateTime.current - 10.hours,
    name: Faker::Internet.unique.user_name(7..99),
    description: Faker::Name.name,
    user_id: User.order('RANDOM()').first.id,
    challenger_amount: Random.rand(20..500),
    gambler_amount: Random.rand(20..2000),
    bet_limit: Random.rand(1..7),
    checked: true,
    result: Random.rand(1..3)
  )
  if user_bet.save(validate: false)
    admin = User.where(role: 'admin').order('RANDOM()').first
    Assignment.create(user_id: admin.id, user_bet_id: user_bet.id)
  end
end

grands_amount.times do
  grand = Grand.create(
    amount: Random.rand(1..1000),
    user_id: User.where(email: 'j123@uc.cl').order('RANDOM()').first.id,
    checked: true
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
