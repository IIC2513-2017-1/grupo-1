require 'test_helper'

class UserBetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_bet = user_bets(:one)
    @user = users(:one)
  end

  test 'should get index' do
    get user_bets_url
    assert_response :success
  end

  test 'should get new' do
    get new_user_bet_url
    assert_response :success
  end

  test 'should create user_bet' do
    assert_difference('UserBet.count') do
      post user_bets_url, params: { user_bet: {
        bet_limit: 1,
        challenger_amount: 1,
        description: 'hola',
        end_date: Date.today,
        gambler_amount: 1,
        name: 'asdasda',
        start_date: Date.today,
        user_id: @user_bet.user_id
      } }
    end

    assert_redirected_to user_bet_url(UserBet.last)
  end

  test 'should show user_bet' do
    get user_bet_url(@user_bet)
    assert_response :success
  end

  test 'should get edit' do
    get edit_user_bet_url(@user_bet)
    assert_response :success
  end

  test 'should update user_bet' do
    patch user_bet_url(@user_bet), params: { user_bet: {
      bet_limit: @user_bet.bet_limit,
      challenger_amount: @user_bet.challenger_amount,
      description: @user_bet.description,
      end_date: @user_bet.end_date,
      gambler_amount: @user_bet.gambler_amount,
      name: @user_bet.name,
      start_date: @user_bet.start_date
    } }
    assert_redirected_to user_bet_url(@user_bet)
  end

  test 'should destroy user_bet' do
    assert_difference('UserBet.count', -1) do
      delete user_bet_url(@user_bet)
    end

    assert_redirected_to user_bets_url
  end
end
