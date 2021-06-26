class TasksController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update]

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "タスクの投稿が完了しました！"
      redirect_to task_path(@task)
    else
      render 'tasks/new'
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = Task.find(params[:id])
    if @task.update_attributes(task_params)
      flash[:success] = "タスクを更新しました！"
      redirect_to @task
    else
      render 'edit'
    end
  end

  def destroy
    @task = Task.find(params[:id])
    if current_user.admin? || current_user?(@task.user)
      @task.destroy
      flash[:success] = "タスクの削除をしました"
      redirect_to request.referrer == user_url(@task.user) ? user_url(@task.user) : root_url
    else
      flash[:danger] = "他人のタスクは削除できません"
      redirect_to root_url
    end
  end

  private

  #タスクの登録に必要な情報
    def task_params
      params.require(:task).permit(:name, :introduction)
    end

    def correct_user
      # 現在のユーザーが更新対象のタスクを保有しているかどうか確認
      @task = current_user.tasks.find_by(id: params[:id])
      redirect_to root_url if @task.nil?
    end
end
