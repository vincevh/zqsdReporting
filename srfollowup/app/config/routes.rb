Rails.application.routes.draw do

  get 'users' => 'users#index'
  post 'users' => 'users#create'
  get 'users/:id' => 'users#show'
  patch 'users/:id' => 'users#update'

  get 'sr' => 'sr#index'
  post 'sr' => 'sr#create'
  get 'sr/:id' => 'sr#show'
  patch 'sr/:id' => 'sr#update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
