require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @password = 'password1'
  end

  test 'should get home' do
    get root_url
    assert_response :success
  end

  test 'should get bet_list only when logged in' do
    get bet_list_url
    assert_response :redirect
    log_in(@user, @password)
    get bet_list_url
    assert_response :success
  end

  test 'should search bet_list only when logged in' do
    get bet_list_search_url, params: { user: '',
                                       min_gambler_amount: '',
                                       max_gambler_amount: '',
                                       min_challenger_amount: '',
                                       max_challenger_amount: '' }
    assert_response :redirect
    log_in(@user, @password)
    get bet_list_search_url, params: { user: '',
                                       min_gambler_amount: '',
                                       max_gambler_amount: '',
                                       min_challenger_amount: '',
                                       max_challenger_amount: '' }
    assert_response :success
    assert_template 'bet_list'
    assert_select 'div.meesbets div.meesbets-content', 1
  end

  # test 'should get users' do
  #   get users_url
  #   assert_response :success
  # end

  test 'make a bet' do
    bet = user_bets(:two)
    log_in(@user, @password)
    get bet_list_url
    assert_template 'pages/bet_list'
    assert_difference('@user.accepted_bets.count') do
      post bet_list_url, params: { user_id: @user.id, bet_id: bet.id }
    end
  end

end
