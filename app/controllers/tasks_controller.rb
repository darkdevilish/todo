class TasksController < ApplicationController
  def index
  	@task = Task.new
  end

  def create
		@task = Task.create(task_param)
		@task.completed = false
		@task.save
		redirect_to root_path
	end

private
	def task_param
		params.require(:task).permit(:title)
	end
end
