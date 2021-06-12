class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user #@userでログインするということ
      flash[:success] = "タスクシェアへようこそ！"
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params_update)
      flash[:success] = "プロフィールを更新しました！"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
  end

  private

    #ユーザー登録に必要な情報
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    #ユーザー更新に必要な情報
    def user_params_update
      params.require(:user).permit(:name, :email, :introduction)
    end

    #ログインしている本人かどうかの確認
    def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
        flash[:danger] = "このページへはアクセスできません"
        redirect_to(root_url)
      end
    end
end
