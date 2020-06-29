# User Resource Controller
class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[index edit update]
  before_action :correct_user,   only: %i[edit update]

  def index
    @users = User.all
  end

  # Userページ表示
  def show
    @user = User.find(params[:id])
  end

  # User新規作成 初期表示
  def new
    @user = User.new
  end

  # User作成
  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to user_url(@user)
    else
      render 'new'
    end
  end

  # User編集 初期表示
  def edit
  end

  # User更新
  def update
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # beforeアクション

    # ログイン済ユーザーかどうか確認
    def logged_in_user
      return if logged_in?

      store_location
      flash[:danger] = 'Please log in.'
      redirect_to login_url
    end

    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
