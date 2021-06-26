class UsersController < ApplicationController
  #ログインしなきゃダメ
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  #本人じゃなきゃダメ
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @tasks = @user.tasks.paginate(page: params[:page], per_page: 5)
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
    @user = User.find(params[:id])
    #管理者の場合(adminユーザー)
    if current_user.admin?
      @user.destroy
      flash[:success] = "ユーザーの削除に成功しました"
      redirect_to users_url
    #管理者ではないが本人の場合
    elsif current_user?(@user)
      @user.destroy
      flash[:success] = "自分のアカウントを削除しました"
      redirect_to root_url
    else
      flash[:danger] = "他人のアカウントは削除できません"
      redirect_to root_url
    end
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
