# Task list app made By [Anthony Gonzalez](https://github.com/darkdevilish)

## [Live Demo](https://ewravjpz.herokuapp.com/)

This simple todo list app is made to demonstrate how to use the ruby on rails built in ajax functionality. It was inspired by this [tutorial](https://www.youtube.com/watch?v=2wCpkOk2uCg) made by [Max Sandelin](https://github.com/themaxsandelin). You can grab the theme in his repo [here](https://github.com/themaxsandelin/todo).

Once you unzip the repo and create a new rails app, go to the resources folder where you will find the css folder. From there copy the reset.css file to your stylesheets folder located in the app/assets folder of your new rails app.

## Steps

1. [UI](#ui)
2. [New Task Form Without Ajax](#new-task-form-without-ajax)
3. [List All Tasks](#list-all-tasks)
4. [Update Form Without Ajax](#update-form-without-ajax)
5. [Destroy Form Without Ajax](#destroy-form-without-ajax)
6. [New Form With Ajax](#new-form-with-ajax)
7. [Update Form With Ajax](#update-form-with-ajax)
8. [Destroy Form with Ajax](#destroy-form-with-ajax)

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

Create task_param private method to whitelist the title param.

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
@todo = Task.where(completed: false).order(id: :desc)
@completed_tasks = Task.where(completed: true).order(id: :desc)
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

Create a form tag in the update form partial with the put method and a button tag. Copy the update svg from the main.js file located in your unzipped repo in the resources/js folder to the button tag that you just created.

```ruby
<%= form_tag({:action => "update", :id => task.id}, method: "put") do %>
  <%= button_tag(:class => "complete") do %>
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 22 22" style="enable-background:new 0 0 22 22;" xml:space="preserve"><rect y="0" class="noFill" width="22" height="22"/><g><path class="fill" d="M9.7,14.4L9.7,14.4c-0.2,0-0.4-0.1-0.5-0.2l-2.7-2.7c-0.3-0.3-0.3-0.8,0-1.1s0.8-0.3,1.1,0l2.1,2.1l4.8-4.8c0.3-0.3,0.8-0.3,1.1,0s0.3,0.8,0,1.1l-5.3,5.3C10.1,14.3,9.9,14.4,9.7,14.4z"/></g></svg>
  <% end %>
<% end %>
```

Do the same for the destroy form partial but made the method delete and add a data confirm to the button tag.

```ruby
<%= form_tag({:action => "destroy", :id => task.id}, method: "delete") do %>
  <%= button_tag( :class => "remove", :data => { confirm: "Are you sure?" }) do %>
    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 22 22" style="enable-background:new 0 0 22 22;" xml:space="preserve"><rect class="noFill" width="22" height="22"/><g><g><path class="fill" d="M16.1,3.6h-1.9V3.3c0-1.3-1-2.3-2.3-2.3h-1.7C8.9,1,7.8,2,7.8,3.3v0.2H5.9c-1.3,0-2.3,1-2.3,2.3v1.3c0,0.5,0.4,0.9,0.9,1v10.5c0,1.3,1,2.3,2.3,2.3h8.5c1.3,0,2.3-1,2.3-2.3V8.2c0.5-0.1,0.9-0.5,0.9-1V5.9C18.4,4.6,17.4,3.6,16.1,3.6z M9.1,3.3c0-0.6,0.5-1.1,1.1-1.1h1.7c0.6,0,1.1,0.5,1.1,1.1v0.2H9.1V3.3z M16.3,18.7c0,0.6-0.5,1.1-1.1,1.1H6.7c-0.6,0-1.1-0.5-1.1-1.1V8.2h10.6V18.7z M17.2,7H4.8V5.9c0-0.6,0.5-1.1,1.1-1.1h10.2c0.6,0,1.1,0.5,1.1,1.1V7z"/></g><g><g><path class="fill" d="M11,18c-0.4,0-0.6-0.3-0.6-0.6v-6.8c0-0.4,0.3-0.6,0.6-0.6s0.6,0.3,0.6,0.6v6.8C11.6,17.7,11.4,18,11,18z"/></g><g><path class="fill" d="M8,18c-0.4,0-0.6-0.3-0.6-0.6v-6.8c0-0.4,0.3-0.6,0.6-0.6c0.4,0,0.6,0.3,0.6,0.6v6.8C8.7,17.7,8.4,18,8,18z"/></g><g><path class="fill" d="M14,18c-0.4,0-0.6-0.3-0.6-0.6v-6.8c0-0.4,0.3-0.6,0.6-0.6c0.4,0,0.6,0.3,0.6,0.6v6.8C14.6,17.7,14.3,18,14,18z"/></g></g></g></svg>
  <% end %>
<% end %>
```

For the task partial make a list to display each individual task render the partials for the update and destroy forms that we created passing the task variable that we will be sending in the index view.

```ruby
<li>
  <%= task.title %>
  <div class="buttons">
    <%= render "destroy_form", task: task %>
    <%= render "update_form", task: task %>
  </div>
</li>
```

To list the tasks in the index view loop through the instance variables that we created in the respective sections and render the task partial passing the variable.

```ruby
# Uncompleted tasks
<% @todo.each do |task| %>
  <%= render "task", task: task %>
<% end %>

# completed tasks
<% @completed_tasks.each do |task| %>
  <%= render "task", task: task %>
<% end %>
```

### Update Form Without Ajax

Now that we can list all the tasks let's make the update form work. In the tasks controller create an update action with the following:

```ruby
def update
  @task = Task.find(params[:id])
  if @task.completed
    @task.update(completed: false)
  else
    @task.update(completed: true)
  end
  redirect_to root_path
end
```

### Destroy Form Without Ajax

Back in the tasks controller create the destroy action with the following:

```ruby
def destroy
  @task = Task.find(params[:id])
  @task.destroy
  redirect_to root_path
end
```

### New Form With Ajax

Now everything is cool and dandy but there's a page refresh everytime an action happens, the solution is to use ajax and rails comes equipped with that functionality built in. Go to the new form partial and in the form after tasks_path make the remote option equal to true.

```ruby
<%= form_for @task, url: tasks_path, remote: true do |f| %>
```

Now in the tasks controller in your create action you need create a respond_to block that allows the controller to serve the ajax request.

```ruby
respond_to do |format|
  format.html { redirect_to root_path}
  format.js
end
```

To respond with javascript you need to create a .js.erb file with the same name of the action in this case will be create.js.erb in your tasks folder your app views, this will allow you to use ruby and javascript in the same file.

Use some jquery to grab the item id in your new form, that's the text field and make the value equal to an empty string to reset the input. Prepend the task that you just created to the todo id, that's the unorder list where you list the uncompleted tasks. You accomplished that using embedded ruby to render the task partial with the instance variable from your create action in your controller and use the hide and fadeIn jquery functions to smoove user interface.

```javascript
$("#item").val("");
$('#todo').prepend( $("<%= j render 'task', task: @task %>").hide().fadeIn(1100) );
```

### Update Form With Ajax

To make the update form work with ajax is the same process that we already did with the new form, what changes here is the js.erb file. First of all we will need to grab the id of the item we're deleting from the tasks list. Right now we're not giving them one so go ahead and go to the task partial, make the list to the task.id.

```html
<li id="<%= task.id %>">
```

Use embedded ruby to grab the id of the instance variable in your update action where you're finding the corresponding task and use the remove jquery function to delete the item. Then depending on the status of the instance variable in your update action you will prepend to the corresponding sections in your html.

```javascript
$("#<%= @task.id %>").remove();

<% if @task.completed %>
    $("#completed").prepend( $("<%= j render 'task', task: @task %>").hide().fadeIn(1100) );
<% else %>
    $("#todo").prepend( $("<%= j render 'task', task: @task %>").hide().fadeIn(1100) );
<% end %>
```

### Destroy Form With Ajax

Everything is the same except that this time in the js.erb file we are only finding the id of the item with jquery and removing it.

```javascript
$("#<%= @task.id %>").fadeOut(1000, function() {
  $(this).remove();
});
```