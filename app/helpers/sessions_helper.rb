# セッション用helper module
module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ログイン中のユーザーを返す
  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  # ユーザーがログインしていればtrue、その他はfalseを返す
  def logged_in?
    !current_user.nil?
  end
end
