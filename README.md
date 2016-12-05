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
