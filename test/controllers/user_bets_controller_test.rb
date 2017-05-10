require 'test_helper'

class UserBetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user_bet = user_bets(:one)
    @user = users(:one)
    @password = 'password1'
  end

  test 'should get index only when logged in' do
    get user_bets_url
    assert_response :redirect
    log_in @user, @password
    get user_bets_url
    assert_response :success
  end

  test 'should get new only when logged in' do
    get new_user_bet_url
    assert_response :redirect
    log_in @user, @password
    get new_user_bet_url
    assert_response :success
  end

  test 'should create user_bet only when logged in' do
    assert_no_difference('UserBet.count') do
      post user_bets_url, params: { user_bet: {
        bet_limit: 1,
        challenger_amount: 1,
        description: 'hola',
        end_date: DateTime.current + 4.days,
        gambler_amount: 1,
        name: 'asdasdaasd',
        start_date: DateTime.current + 3.days,
        user_id: @user.id
      } }
    end
    log_in @user, @password
    assert_difference('UserBet.count') do
      post user_bets_url, params: { user_bet: {
        bet_limit: 1,
        challenger_amount: 1,
        description: 'hola',
        end_date: DateTime.current + 4.days,
        gambler_amount: 1,
        name: 'asdasdaasd',
        start_date: DateTime.current + 3.days,
        user_id: @user.id
      } }
    end

    assert_redirected_to user_bet_url(UserBet.last)
  end

  test 'should show user_bet only when logged in' do
    get user_bet_url(@user_bet)
    assert_response :redirect
    log_in @user, @password
    get user_bet_url(@user_bet)
    assert_response :success
  end

  test 'should get edit only when logged in' do
    get edit_user_bet_url(@user_bet)
    assert_response :redirect
    log_in @user, @password
    get edit_user_bet_url(@user_bet)
    assert_response :success
  end

  test 'should update user_bet only when logged in' do
    patch user_bet_url(@user_bet), params: { user_bet: {
      bet_limit: @user_bet.bet_limit,
      challenger_amount: @user_bet.challenger_amount,
      description: @user_bet.description,
      end_date: @user_bet.end_date,
      gambler_amount: @user_bet.gambler_amount,
      name: @user_bet.name,
      start_date: @user_bet.start_date
    } }
    assert_redirected_to login_path
    log_in @user, @password
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

  test 'should destroy user_bet only when logged in' do
    assert_no_difference('UserBet.count') do
      delete user_bet_url(@user_bet)
    end
    assert_redirected_to login_path
    log_in @user, @password
    assert_difference('UserBet.count', -1) do
      delete user_bet_url(@user_bet)
    end
    assert_redirected_to user_bets_url
  end
end
