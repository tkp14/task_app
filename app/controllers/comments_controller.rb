class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    #どのタスクか
    @comment = Task.find(params[:task_id])
    if @comment.save
      flash[:success] = "コメントを書き込みました"
      redirect_to @user
    else
      redirect_to root_url
    end
  end

  def destroy
    #どのタスクか
    @comment = Task.find(params[:task_id])
    if current_user.admin? || current_user?(@task.user)
      @comment.destroy
      flash[:success] = "コメントを削除しました"
      redirect_to @task
    else
      flash[:danger] = "コメントの削除はできません"
      redirect_to root_url
    end
  end
end
