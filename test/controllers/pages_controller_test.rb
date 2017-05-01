require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get root_url
    assert_response :success
  end

  test 'should get bet_list' do
    get bet_list_url
    assert_response :success
  end

  test 'should get users' do
    get users_url
    assert_response :success
  end

  test 'should get user bets' do
    get user_bets_url
    assert_response :success
  end

  test 'make a bet' do
    get bet_list_url
    assert_template 'pages/bet_list'
    user = users(:one)
    bet = user_bets(:two)
    assert_difference('user.accepted_bets.count') do
      post bet_list_url, params: { user_id: user.id, bet_id: bet.id }
    end
  end

end
