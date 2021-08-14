class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    #どのタスクか
    @task = Task.find(params[:task_id])
    if current_user.comment(@task)
      flash[:success] = "コメントを書き込みました"
      redirect_to @user
    else
      redirect_to root_url
    end
  end

  def destroy
    #どのタスクか
    @task = Task.find(params[:task_id])
    if current_user.admin? || current_user?(@task.user)
      @task.destroy
      flash[:success] = "コメントを削除しました"
      redirect_to @task
    else
      flash[:danger] = "コメントの削除はできません"
      redirect_to root_url
    end
  end
end
