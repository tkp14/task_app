class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    #どのタスクか
    #先ほどのhidden_field_tagで送られてきたdish_idを使用
    @task = Task.find(params[:task_id])
    #誰のか
    @user = @task.user
    #user_idはそのままcurrent_userのidとし、コメントの内容はparams[:comment][:content]で受け取っています
    @comment = @task.comments.build(user_id: current_user.id, content: params[:comment][:content])
    if !@task.nil? && @comment.save
      flash[:success] = "コメントを書き込みました"
    else
      flash[:danger] = "空のコメントは投稿できません。"
    end
    redirect_to request.referer || root_url
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
