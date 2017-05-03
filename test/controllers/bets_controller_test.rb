require 'test_helper'

class BetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @bet = bets(:one)
    @grand = grands(:one)
    @competitor = competitors(:one)
  end

  test "should get index" do
    get bets_url
    assert_response :success
  end

  test "should get new" do
    get new_bet_url
    assert_response :success
  end

  test "should create bet" do
    assert_difference('Bet.count') do
      post bets_url, params: { bet: { country: @bet.country, sport: @bet.sport, start_date: @bet.start_date } }
    end

    assert_redirected_to bet_url(Bet.last)
  end

  test "should show bet" do
    get bet_url(@bet)
    assert_response :success
  end

  test "should get edit" do
    get edit_bet_url(@bet)
    assert_response :success
  end

  test "should update bet" do
    patch bet_url(@bet), params: { bet: { country: @bet.country, sport: @bet.sport, start_date: @bet.start_date } }
    assert_redirected_to bet_url(@bet)
  end

  test "should destroy bet" do
    assert_difference('Bet.count', -1) do
      delete bet_url(@bet)
    end

    assert_redirected_to bets_url
  end

  def get_multiplicator(grand)
    multiplier = 1
    grand.bets_per_grand.each do |bet|
      selection = bet.selection
      mul = bet.bet.competitors_per_bet.find_by(competitor_id:
       selection).multiplicator
      multiplier *= mul
    end
    multiplier
  end

  test 'should create make_up' do
    Part.create(
      bet_id: @bet.id,
      competitor_id: @competitor.id,
      multiplicator: 1.8
    )
    make = MakeUp.new(
      grand_id: @grand.id,
      bet_id: @bet.id,
      selection: @competitor.id
    )
    make2 = MakeUp.new(
      grand_id: @grand.id,
      bet_id: @bet.id,
      selection: @competitor.id + 1
    )
    make3 = MakeUp.new(
      grand_id: @grand.id,
      bet_id: @bet.id,
      selection: @competitor.id
    )
    assert make.save
    assert_not make2.save
    assert_not make3.save
    mul = get_multiplicator(@grand)
    assert mul == 1.8
  end
end
