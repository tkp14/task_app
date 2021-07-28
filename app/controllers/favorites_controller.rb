class FavoritesController < ApplicationController
  before_action :logged_in_user

  def index
    @favorites = current_user.favorite
  end

  def create
    @task = Task.find(params[:task_id])
    @user = @task.user
    current_user.favorite(@task)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    @task = Task.find(params[:task_id])
    current_user.favorites.find_by(task_id: @task.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
