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
      # 自分以外のユーザーからコメントがあったときのみ通知を作成
      if @user != current_user
        @user.notifications.create(task_id: @task.id, variety: 2,
                                   from_user_id: current_user.id,
                                   content: @comment.content)#コメントは通知2
        @user.update_attribute(:notification, true)
      end
    else
      flash[:danger] = "空のコメントは投稿できません。"
    end
    redirect_to request.referer || root_url
  end

  def destroy
    #コメントのid
    @comment = Comment.find(params[:id])
    #そのコメントのidを持ったタスク
    @task = @comment.task
    #@comment.user_idだけでは他のユーザーでも削除できてしまう
    #ログインしているユーザーとコメントしたuser_idが同じ場合
    if current_user.id == @comment.user_id
      @comment.destroy
      flash[:success] = "コメントを削除しました"
    else
      flash[:danger] = "コメントの削除はできません"
    end
    redirect_to task_url(@task)
  end
end
