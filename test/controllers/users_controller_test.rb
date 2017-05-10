require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @password = 'password1'
  end

  test 'should get index only when logged in' do
    get users_url
    assert_response :redirect
    log_in(@user, @password)
    assert_response :redirect
    follow_redirect!
    assert_template 'bets/index'
    get users_url
    assert_response :success
  end

  # test 'should get new' do
  #   get new_user_url
  #   assert_response :success
  # end

  test 'should create user' do
    assert_difference('User.count') do
      post users_url, params: { user: { email: 'usuarionoexistente@gmail.com',
                                        role: 'admin',
                                        username: 'usuarionoexistente',
                                        name: 'Usuario',
                                        lastname: 'Noexistente',
                                        description: 'descripcion',
                                        birthday: Date.today,
                                        password: 'foobar',
                                        password_confirmation: 'foobar' } }
    end

    assert_redirected_to login_url
  end

  test 'should show user only when logged in' do
    get user_url(@user)
    assert_response :redirect
    log_in(@user, @password)
    get users_url
    assert_response :success
  end

  test 'should get edit only when logged in' do
    get edit_user_url(@user)
    assert_response :redirect
    log_in(@user, @password)
    get edit_user_url(@user)
    assert_response :success
  end

  test 'should update user only when logged in' do
    patch user_url(@user), params: { user: { email: @user.email,
                                             role: @user.role,
                                             username: @user.username } }
    assert_redirected_to login_path
    log_in(@user, @password)
    patch user_url(@user), params: { user: { email: @user.email,
                                             role: @user.role,
                                             username: @user.username } }
    assert_redirected_to user_url(@user)
  end

  # test 'should destroy user' do
  #   assert_difference('User.count', -1) do
  #     delete user_url(@user)
  #   end
  #
  #   assert_redirected_to users_url
  # end
end
