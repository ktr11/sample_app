require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get signup_path
    assert_select 'form[action="/users"]'
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: '',
                                          email: 'user@invalid',
                                          password: 'foo',
                                          password_confirmation: 'bar' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert' do
      assert_select 'div.alert-danger'
    end
  end

  test 'valid signup infomation with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not_nil user.email_token
    assert_not user.activated?
    # 有効化していない状態でログインしてみる
    t_log_in_as(user)
    assert_not t_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path('invalid token', p: user.email_token)
    assert_not t_logged_in?
    # トークンは正しいがメールアドレストークンが無効な場合
    get edit_account_activation_path(user.activation_token, p: 'wrong')
    assert_not t_logged_in?
    # 有効化トークン,メールアドレストークンが正しい場合
    get edit_account_activation_path(user.activation_token, p: user.email_token)
    assert user.reload.activated?
    assert_nil user.email_token
    follow_redirect! # テスト対象をリダイレクト先に移すメソッド
    assert_template 'users/show'
    assert_not flash.empty?
    assert t_logged_in?
  end
end
