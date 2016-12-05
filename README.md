# Task list app made By [Anthony Gonzalez](https://github.com/darkdevilish)

This simple todo list app is made to demonstrate how to use the ruby on rails built in ajax functionality. It was inspired by this [tutorial](https://www.youtube.com/watch?v=2wCpkOk2uCg) made by [Max Sandelin](https://github.com/themaxsandelin). You can grab the theme in his repo [here](https://github.com/themaxsandelin/todo).

Once you unzip the repo and create a new rails app, go to the resources folder where you will find the css folder. From there copy the reset.css file to your stylesheets folder located in the app/assets folder of your new rails app.

### UI

Go to the command line and generate a tasks controller with an index action.

```console
rails generate controller Tasks index
```

Get back to the css folder from the repo that you unzipped and copy the contents from the style.css file to tasks.scss located in the app/assets/stylesheets folder of your rails app.

Open the application.html.erb file located in the app/views/layouts folder of your rails app, update the title and copy the roboto font embed below <%= csrf_meta_tags %>from the index.html of the repo. From the same index.html file copy the contents from the body except the javascript script source to index.html.erb file located in the app/views/tasks_controller folder of your rails app.

Open the routes.rb file located in the config folder of your rails app and create resources for your tasks controller except the new show and edit actions because we won't need them. Then make index action of your tasks controller the root.

```ruby
root 'tasks#index'

resources :tasks, except:[:new, :show, :edit]
```

### New Task Form Without Ajax

Now that we have a template to work with let's create a model with a string title and a boolean completed for tasks and migrate the table.

```console
rails g model task title:string completed:boolean
rails db:migrate
```

Go to the the tasks controller and in the index action make an instance variable for new task.

```ruby
@task = Task.new
```

Create task_param private function to whitelist the title param.

```ruby
private
	def task_param
		params.require(:task).permit(:title)
	end
```

Make a create action for tasks controller with an instance variable to create the new task in database, make the completed boolean false, save and redirect to root_path.

```ruby
def create
		@task = Task.create(task_param)
		@task.completed = false
		@task.save
		redirect_to root_path
end
```

Go to index view, create a form_for @task with a text field and a button tag.

```ruby
<%= form_for @task, url: tasks_path do |f| %>
		<%= f.text_field :title, :id =>"item", :placeholder =>"Enter an activity.." %>
		<%= button_tag( :id =>"add") do %>
			<svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"viewBox="0 0 16 16" style="enable-background:new 0 0 16 16;" xml:space="preserve"><g><path class="fill" d="M16,8c0,0.5-0.5,1-1,1H9v6c0,0.5-0.5,1-1,1s-1-0.5-1-1V9H1C0.5,9,0,8.5,0,8s0.5-1,1-1h6V1c0-0.5,0.5-1,1-1s1,0.5,1,1v6h6C15.5,7,16,7.5,16,8z"/></g></svg>
		<% end %>
	<% end %>
```

### List All Tasks

Now that we can create tasks let's list them. Get to the index action of your tasks controller and make an instance variable called todo to grab all the tasks that are not completed order by id desc and another one called completed_tasks to grab the ones that are completed.

```ruby
@todo = Task.where(complete: false).order(id: :desc)
@completed_tasks = Task.where(complete: true).order(id: :desc)
```

Before going forward let's create some partials in our tasks views for the new form, destroy, update and to display an individual task. Go to your tasks views folder and create 4 new files with the following names.

```console
_new_form.html.erb
_task.html.erb
_update_form.html.erb
_destroy_form.html.erb
```

Grab the new form from the index view and place it in the new_form partials and render the partial in the index view.

```ruby
<%= render "new_form" %>
```