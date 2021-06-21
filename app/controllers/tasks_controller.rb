class TasksController < ApplicationController
  before_action :logged_in_user

  def new
    @task = Task.new
  end
end
