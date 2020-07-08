require 'test_helper'

class UsersControllerTest < AbstractControllerTest
  def setup
    super
    @user = users(:michael)       # admin
    @other_user = users(:archer)  # non-admin
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should redirect index when not logged in' do
    get users_path
    assert_redirected_to login_url
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect edit when logged in as wrong user' do
    t_log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'should redirect update when logged in as wrong user' do
    t_log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when logged in as a non-admin' do
    t_log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test 'should get new 2' do
    get '/users/new'
    assert_response :success
    assert_select("input[type='text'][name='user[name]'][id='user_name']", count: 1)
    assert_select("input[type='email'][name='user[email]'][id='user_email']", count: 1)
    assert_select("input[type='password'][name='user[password]'][id='user_password']", count: 1)
    assert_select("input[type='password'][name='user[password_confirmation]']" \
                      "[id='user_password_confirmation']",
                  count: 1)
    assert_select("input[type='submit'][name='commit']", count: 1)
    assert_select('form input', count: 5)
  end

  test 'should get user' do
    id = @user.id
    get "/users/#{id}"
    assert_response :success
    assert_select('title', "#{@user.name} | #{@base_title}")
    gravatar_url = 'https://secure.gravatar.com/avatar/'
    assert_select("img[alt='#{@user.name}'][src*='#{gravatar_url}']")
    assert_select('h1', /#{@user.name}/)
  end
end
