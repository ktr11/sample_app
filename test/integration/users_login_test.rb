require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  # フラッシュメッセージの残留をキャッチする
  test  'login with invalid information' do
    get login_path
    assert_template 'sessions/new'
    post login_path, params: { session: { email: '', password: '' } }
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # ログイン成功時のテスト
  test 'login with valid information' do
    get login_path
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?][data-method=?]', logout_path, 'delete'
    assert_select 'a[href=?]', user_path(@user)
    delete logout_path
    assert_not t_logged_in?
    assert_redirected_to root_url
    delete logout_path # 別タブでもログアウトしたユーザーを想定
    follow_redirect!
    assert_select 'a[href=?]', login_path, count: 1
    assert_select 'a[href=?]', logout_path,      count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
  end

  # remember_digestがNULLでもログアウトは落ちない？
  test 'authenticated? should return false for a user with nil digest' do
    assert_not @user.authenticated?('')
  end

  # remember login のテスト
  test 'login with remembering' do
    t_log_in_as(@user, remember_me: '1')
    assert_equal cookies[:remember_token], assigns(:user).remember_token
  end

  test 'login without remembering' do
    # cookieを保存してログイン
    t_log_in_as(@user, remember_me: '1')
    delete logout_path
    # cookieを削除してログイン
    t_log_in_as(@user, remember_me: '0')
    assert_empty cookies[:remember_token]
  end
end
