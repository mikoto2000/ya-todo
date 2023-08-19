Rails.application.routes.draw do
  resources :todo_statuses
  resources :todos, except: %w[new] do
    collection { post :bulk_insert }
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
