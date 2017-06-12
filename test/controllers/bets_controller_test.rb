require 'test_helper'

class BetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @bet = bets(:one)
    @password = 'password1'
    @grand = grands(:one)
    @competitor = competitors(:one)
  end

  test "should get index" do
    get root_url
    assert_response :success
  end

  # test "should get new" do
  #   get new_bet_url
  #   assert_response :success
  # end

  test "should create grand" do
    log_in(@user, @password)
    assert_difference('Grand.count') do
      post make_up_url, params: { amount: 2, bets(:two).id => competitors(:one).id }
    end
    #assert_redirected_to bet_url(Bet.last)
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
