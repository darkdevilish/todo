Rails.application.routes.draw do
  root 'tasks#index'

  resources :tasks, except:[:new, :show, :edit]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
