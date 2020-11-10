Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get "users/show" => "users#show"
  root to: "memos#index"
  resources :memos, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :users, only: [:show, :edit, :update]
end
