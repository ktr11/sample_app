require 'test_helper'

class UsersControllerTest < AbstractControllerTest
  def setup
    super
    @user = User.new(name: 'Example User', email: 'user@example.com',
      password: 'foobar', password_confirmation: 'foobar')
    @user.save
  end

  test 'should get new' do
    get signup_path
    assert_response :success
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
    assert_select('form.new_user input', count: 5)
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
