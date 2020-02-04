require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'layout links' do
    # rootにリクエスト
    get root_path
    # homeのテンプレートが読み込まれる
    assert_template 'static_pages/home'
    # 各リンクの有無を確認
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path
    assert_select 'a[href=?]', contact_path
    assert_select 'a[href=?]', signup_path
    get contact_path
    assert_select 'title', full_title('Contact')
    get signup_path
    assert_select 'title', full_title('Sign up')
  end
end
