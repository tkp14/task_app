class TasksController < ApplicationController
  before_action :logged_in_user

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

  private

  #タスクの登録に必要な情報
    def task_params
      params.require(:task).permit(:name, :introduction)
    end
end
