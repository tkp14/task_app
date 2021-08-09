class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    #どのタスクか
    @task = Task.find(params[:task_id])
    #誰のか
    @user = @task.user
    current_user.comment(@user)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end

  def destroy
    #どのタスクか
    @task = Task.find(params[:task_id])
    #タスクのidを探し、削除
    current_user.comments.find_by(task_id: @task.id).destroy
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
end
