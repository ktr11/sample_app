# パスワード再設定 コントローラー
class PasswordResetsController < ApplicationController
  before_action :find_user_by_token, only: [:edit]
  before_action :find_user, only: [:update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'Email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'Email address not found'
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      flash[:succsess] = 'Password has been reset.'
      @user.update_columns(email_token: nil, reset_digest: nil)
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # beforeフィルター

    # メールアドレストークンでユーザーの取得
    def find_user_by_token
      @user = User.find_by(email_token: params[:p])
    end

    # メールアドレスでユーザーの取得
    def find_user
      @user = User.find_by(email: params[:email].downcase)
    end

    # 正しいユーザーかどうか確認する
    def valid_user
      unless @user&.activated? &&
             @user&.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = 'Password reset has expired.'
        redirect_to new_password_reset_url
      end
    end
end
