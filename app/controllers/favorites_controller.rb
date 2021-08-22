class FavoritesController < ApplicationController
  before_action :logged_in_user

  def index
    @favorites = current_user.favorites
  end

  def create
    @task = Task.find(params[:task_id])
    @user = @task.user
    #どのtaskにいいねするか
    current_user.favorite(@task)
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
    #自分以外のユーザーからお気に入り登録があった時のみ通知を作成
    if @user != current_user
      @user.notifications.create(task_id: @task.id, variety: 1,
                                 from_user_id: current_user.id)# お気に入り登録は通知種別1
      @user.update_attribute(:notification, true)
    end
  end

  def destroy
    @task = Task.find(params[:task_id])
    current_user.favorites.find_by(task_id: @task.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end
  end
end
