class TasksController < ApplicationController
  def index
    @task = Task.new
    @todo = Task.where(completed: false).order(id: :desc)
    @completed_tasks = Task.where(completed: true).order(id: :desc)
  end

  def create
    @task = Task.create(task_param)
    @task.completed = false
    @task.save

    respond_to do |format|
      format.html { redirect_to root_path}
      format.js
    end
  end

  def update
    @task = Task.find(params[:id])
    if @task.completed
      @task.update(completed: false)
    else
      @task.update(completed: true)
    end

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

  def destroy
    @task = Task.find(params[:id])
    @task.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
  end

private
  def task_param
    params.require(:task).permit(:title)
  end
end
